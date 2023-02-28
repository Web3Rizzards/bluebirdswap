// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// Import LinkTokenInterface and AggregatorV3Interface
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IOptionPricing.sol";

contract BluebirdOptions is Ownable, ReentrancyGuard {
    // Price feed interface
    AggregatorV3Interface internal nftFeed;
    IERC20 public nftToken;
    uint nftPrice;
    uint nftTokenPrice;

    address payable contractAddr;
    address public controller;
    IOptionPricing public optionPricing;
    // Constant value of 1 week
    uint256 public EXPIRY = 604800;
    // Options stored in arrays of structs
    struct Option {
        uint strike; // Price in USD (18 decimal places) option allows buyer to purchase tokens at
        uint expiry; // Unix timestamp of expiration time
        uint id; // Unique ID of option, also array index
        uint latestCost; // Helper to show last updated cost to exercise
        bool isPut; // True if option is a put, false if call
        address[] buyers; // Array of addresses that have bought this option
    }

    uint256 public currentId;
    mapping(address => uint256) public userDeposits;
    mapping(uint256 => Option) public nftOpts;
    mapping(address => mapping(uint256 => uint256)) public userToOptionIdToAmount;
    mapping(address => mapping(uint256 => bool)) public exercised;

    // SAMPLE HISTORICAL PRICES
    uint256[7] public prices;

    constructor(address _nftFeed, address _nftToken, address _controller, address _optionsPricing) {
        // Price feed of NFT
        nftFeed = AggregatorV3Interface(_nftFeed);

        nftToken = IERC20(_nftToken);

        contractAddr = payable(address(this));
        controller = _controller;
        optionPricing = IOptionPricing(_optionsPricing);
        uint _temp = 100 ether / 1000000;
        // Generate random historical prices for 1 week for testing (+- 10%)
        prices[0] = _temp - (_temp / 10);
        prices[1] = _temp + (_temp / 10);
        prices[2] = _temp - (_temp / 5);
        prices[3] = _temp + (_temp / 5);
        prices[4] = _temp - (_temp / 3);
        prices[5] = _temp + (_temp / 3);
        prices[6] = _temp;
    }

    // Set expiry
    function setExpiry(uint256 _expiry) external onlyOwner {
        EXPIRY = _expiry;
    }

    function calculateStrikePrices(uint256 _floorPrice, bool _isPut) internal pure returns (uint256[] memory) {
        uint256[] memory strikePrices = new uint256[](3);
        if (_isPut) {
            // Calculate from floor price 10% lower, 20% lower, 30% lower
            strikePrices[0] = _floorPrice - (_floorPrice / 10);
            strikePrices[1] = _floorPrice - (_floorPrice / 5);
            strikePrices[2] = _floorPrice - (_floorPrice / 3);
            return strikePrices;
        } else {
            // Calculate from floor price 10% higher, 20% higher, 30% higher
            strikePrices[0] = _floorPrice + (_floorPrice / 10);
            strikePrices[1] = _floorPrice + (_floorPrice / 5);
            strikePrices[2] = _floorPrice + (_floorPrice / 3);
        }
        return strikePrices;
    }

    //Returns the latest Nft price
    function getNftPrice() public view returns (uint) {
        (uint80 roundID, int price, uint startedAt, uint timeStamp, uint80 answeredInRound) = nftFeed.latestRoundData();
        // If the round is not complete yet, timestamp is 0
        require(timeStamp > 0, "Round not complete");
        //Price should never be negative thus cast int to unit is ok
        //Price is 8 decimal places and will require 1e10 correction later to 18 places
        return uint(price);
    }

    //Updates prices to latest
    function updatePrices() internal {
        nftPrice = getNftPrice();
        nftTokenPrice = nftPrice / 1000000;
    }

    function depositNftToken(uint amount) public nonReentrant {
        require(nftToken.transferFrom(msg.sender, address(this), amount), "Incorrect amount of NFT Token sent");
        userDeposits[msg.sender] += amount;
    }

    function writeOption() external {
        // Require controller address only
        require(msg.sender == controller, "Only controller can write options");
        updatePrices();
        // Get strike prices
        uint256[] memory _strikePricesCall = calculateStrikePrices(nftPrice, false);
        uint256[] memory _strikePricesPut = calculateStrikePrices(nftPrice, true);
        uint256 _start = block.timestamp;
        // Empty address array
        address[] memory empty;
        // Loop through strike prices and get all premiums and push to nftOpts array
        for (uint i = 0; i < _strikePricesCall.length; i++) {
            // Get premium
            nftOpts[currentId] = Option(_strikePricesCall[i], _start + EXPIRY, currentId, 0, false, empty);
            nftOpts[currentId + 1] = Option(_strikePricesPut[i], _start + EXPIRY, currentId + 1, 0, true, empty);

            currentId += 2;
        }
    }

    // View premium of option
    function viewPremium(uint256 _id) public view returns (uint256) {
        uint256 _nftPrice = getNftPrice();
        return optionPricing.getOptionPrice(false, nftOpts[_id].expiry, nftOpts[_id].strike, _nftPrice, 0);
    }

    function computeStandardDeviation(uint256[] memory prices) internal pure returns (uint256) {
        uint256 n = prices.length;
        uint256 mean = 0;

        // Compute mean
        for (uint256 i = 0; i < n; i++) {
            mean += prices[i];
        }
        mean = mean / n;

        // Compute sum of squared differences
        uint256 sumSquaredDifferences = 0;
        for (uint256 i = 0; i < n; i++) {
            uint256 difference = prices[i] - mean;
            sumSquaredDifferences += difference * difference;
        }

        // Compute variance and standard deviation
        uint256 variance = sumSquaredDifferences / n;
        uint256 standardDeviation = sqrt(variance);

        return standardDeviation;
    }

    function sqrt(uint256 x) internal pure returns (uint256) {
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }

    //Purchase a call option, needs desired token, ID of option and payment
    function buyOption(uint256 _id, uint256 _amount, bool _isPut, uint256 _viewPremium) public {
        require(
            nftToken.transferFrom(msg.sender, address(this), _amount),
            "Incorrect amount of NFT Token sent for amount"
        );
        // Add max buy
        updatePrices();
        require(nftOpts[_id].expiry < block.timestamp, "Option is expired and cannot be bought");
        uint256 _expiry = nftOpts[_id].expiry;
        uint256 _premium;
        uint256 _baseIv = computeStandardDeviation(prices);
        if (_isPut) {
            _premium = optionPricing.getOptionPrice(true, _expiry, nftOpts[_id].strike, nftTokenPrice, baseIv);
        } else {
            _premium = optionPricing.getOptionPrice(false, _expiry, nftOpts[_id].strike, nftTokenPrice, baseIv);
        }
        // If premium is not within 1% of view premium, revert
        require(_premium >= _viewPremium - (_viewPremium / 100), "Premium is not within 1% of view premium");

        //Transfer premium payment from buyer to writer
        require(
            nftToken.transferFrom(msg.sender, address(this), _premium),
            "Incorrect amount of NFT Token sent for premium"
        );

        nftOpts[_id].buyers.push(msg.sender);
    }

    /**
     * @notice Calculate PnL for an option holder
     * @param isPut is put option
     * @param exercisePrice strike price of the option
     * @param numOptions number of options
     * @param spotPrice spot price of the underlying asset at the time of exercise
     * @param exerciseCost cost of exercising the option
     */
    function calculatePnL(
        bool isPut,
        uint256 exercisePrice,
        uint256 numOptions,
        uint256 spotPrice,
        uint256 exerciseCost
    ) public view returns (int256) {
        int256 pnl = 0;

        // Calculate profit or loss on the option position
        if (isPut) {
            if (spotPrice < exercisePrice) {
                pnl = int256(exercisePrice - spotPrice) * int256(numOptions);
            }
        } else {
            if (spotPrice > exercisePrice) {
                pnl = int256(spotPrice - exercisePrice) * int256(numOptions);
            }
        }

        // Subtract transaction costs
        pnl -= int256(exerciseCost) * int256(numOptions);

        return pnl;
    }

    function exercise(uint256 _id) public {
        require(userToOptionIdToAmount[msg.sender][_id] > 0, "You do not own this option");
        require(!exercised[msg.sender][_id], "Option has already been exercised");
        require(nftOpts[_id].expiry > block.timestamp, "Option is not expired");
        updatePrices();
        // Calculate pnl
        uint256 _amount = calculatePnL(nftOpts[_id].isPut, nftOpts[_id].strike, 1, nftTokenPrice, 0);
        if (_amount > 0) {
            // Transfer collateral from user to protocol
            require(
                nftToken.transferFrom(msg.sender, address(this), nftOpts[_id].strike),
                "Error: collateral transfer failed"
            );
        }
        exercised[msg.sender][_id] = true;
    }
}
