// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// Import LinkTokenInterface and AggregatorV3Interface
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract BluebirdCallOptions {
    // Price feed interface
    AggregatorV3Interface internal nftFeed;
    IERC20 public nftToken;
    uint nftPrice;

    address payable contractAddr;
    
    // Options stored in arrays of structs
    struct option {
        uint strike; // Price in USD (18 decimal places) option allows buyer to purchase tokens at
        uint premium; // Fee in contract token that option writer charges
        uint expiry; // Unix timestamp of expiration time
        uint amount; // Amount of tokens the option contract is for
        bool exercised; // Has option been exercised
        bool canceled; // Has option been canceled
        uint id; // Unique ID of option, also array index
        uint latestCost; // Helper to show last updated cost to exercise
        address writer; // Issuer of option
        address buyer; // Buyer of option
    }
    option[] public nftOpts;

    //Kovan feeds: https://docs.chain.link/docs/reference-contracts
    constructor(address _nftFeed, address _nftToken) {
        // Price feed of NFT
        nftFeed = AggregatorV3Interface(_nftFeed);

        nftToken = IERC20(_nftToken);

        contractAddr = payable(address(this));
    }

    //Returns the latest Nft price
    function getNftPrice() public view returns (uint) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = nftFeed.latestRoundData();
        // If the round is not complete yet, timestamp is 0
        require(timeStamp > 0, "Round not complete");
        //Price should never be negative thus cast int to unit is ok
        //Price is 8 decimal places and will require 1e10 correction later to 18 places
        return uint(price);
    }
    
    //Updates prices to latest
    function updatePrices() internal {
        nftPrice = getNftPrice();
    }
    
    //Allows user to write a covered call option
    //Takes which token, a strike price(USD per token w/18 decimal places), premium(same unit as token), expiration time(unix) and how many tokens the contract is for
    function writeOption(uint strike, uint premium, uint expiry, uint tknAmt) public {
        updatePrices();
        require(nftToken.transferFrom(msg.sender, contractAddr, tknAmt), "Incorrect amount of nftToken supplied");
        uint latestCost = strike*tknAmt / nftPrice * 10**10;
        nftOpts.push(option(strike, premium, expiry, tknAmt, false, false, nftOpts.length, latestCost, msg.sender, address(0)));
        
    }
    
    //Allows option writer to cancel and get their funds back from an unpurchased option
    function cancelOption(uint ID) public payable {
        require(msg.sender == nftOpts[ID].writer, "You did not write this option");
        require(!nftOpts[ID].canceled && nftOpts[ID].buyer == address(0), "This option cannot be canceled");
        require(nftToken.transferFrom(address(this), nftOpts[ID].writer, nftOpts[ID].amount), "Incorrect amount of NFT Tokensent");
        nftOpts[ID].canceled = true;
        
    }
    
    //Purchase a call option, needs desired token, ID of option and payment
    function buyOption(uint ID) public {
        updatePrices();
        require(!nftOpts[ID].canceled && nftOpts[ID].expiry > block.timestamp, "Option is canceled/expired and cannot be bought");
        //Transfer premium payment from buyer to writer
        require(nftToken.transferFrom(msg.sender, nftOpts[ID].writer, nftOpts[ID].premium), "Incorrect amount of LINK sent for premium");
        nftOpts[ID].buyer = msg.sender;
    
    }
    
    //Exercise your call option, needs desired token, ID of option and payment
    function exercise(uint ID) public payable {
        //If not expired and not already exercised, allow option owner to exercise
        //To exercise, the strike value*amount equivalent paid to writer (from buyer) and amount of tokens in the contract paid to buyer
     
        require(nftOpts[ID].buyer == msg.sender, "You do not own this option");
        require(nftOpts[ID].exercised, "Option has already been exercised");
        require(nftOpts[ID].expiry > block.timestamp, "Option is expired");
        updatePrices();
        uint exerciseVal = nftOpts[ID].strike*nftOpts[ID].amount;
        uint equivLink = exerciseVal / nftPrice * 10**10;
        //Buyer exercises option, exercise cost paid to writer
        require(nftToken.transferFrom(msg.sender, nftOpts[ID].writer, equivLink), "Incorrect Nft token amount sent to exercise");
        //Pay buyer contract amount of LINK
        require(nftToken.transfer(msg.sender, nftOpts[ID].amount), "Error: buyer was not paid");
        nftOpts[ID].exercised = true;
        
    }
    
    //Allows writer to retrieve funds from an expired, non-exercised, non-canceled option
    function retrieveExpiredFunds(uint ID) public payable {
        require(msg.sender == nftOpts[ID].writer, "You did not write this option");
        require(nftOpts[ID].expiry <= block.timestamp && !nftOpts[ID].exercised && !nftOpts[ID].canceled, "This option is not eligible for withdraw");
        require(nftToken.transferFrom(address(this), nftOpts[ID].writer, nftOpts[ID].amount), "Incorrect amount of nft Token sent");
        nftOpts[ID].canceled = true;
        
    }
    
    //This is a helper function to help the user see what the cost to exercise an option is currently before they do so
    //Updates lastestCost member of option which is publicly viewable
    function updateExerciseCost(uint ID) public {
        updatePrices();
        nftOpts[ID].latestCost = nftOpts[ID].strike * nftOpts[ID].amount / nftPrice * 10**10;
        
    }
}