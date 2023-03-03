// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// Import LinkTokenInterface and AggregatorV3Interface
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import { IOptionPricing } from "./interfaces/IOptionPricing.sol";
import { IBluebirdOptions } from "./interfaces/IBluebirdOptions.sol";
import { IBB20 } from "./interfaces/IBB20.sol";
import { BluebirdMath } from "./libraries/BluebirdMath.sol";
import { IBluebirdManager } from "./interfaces/IBluebirdManager.sol";
import "hardhat/console.sol";

contract BluebirdOptions is IBluebirdOptions, Ownable, ReentrancyGuard {
    // Price feed interface
    AggregatorV3Interface internal nftFeed;

    // Fractionalized NFT
    IERC20 public nftToken;
    address payable contractAddr;
    address public controller;
    IBluebirdManager public bluebirdManager;
    IOptionPricing public optionPricing;

    uint256 public EXPIRY = 7 days;
    uint256 public startTimeBuy;
    uint256 public startTimeEpoch;
    uint256 public epoch;
    bool public epochEnded = true;
    uint256 public liquidityProvidingTime = 30 seconds;
    // Options stored in arrays of structs
    struct Option {
        uint strike; // Price in USD (18 decimal places) option allows buyer to purchase tokens at
        uint expiry; // Unix timestamp of expiration time
        uint amount; // Amount of tokens option allows buyer to purchase
        uint id; // Unique ID of option, also array index //TODO: REMOVE
        bool isPut; // True if option is a put, false if call
        address[] buyers; // Array of addresses that have bought this option //TODO: REMOVE
    }

    uint256 public currentId;
    uint256 public maxBuyCall;
    uint256 public maxBuyPut;
    mapping(address => mapping(uint256 => uint256)) public userDeposits;
    mapping(uint256 => Option) public nftOpts;
    mapping(address => mapping(uint256 => uint256))
        public userToOptionIdToAmount;
    mapping(address => mapping(uint256 => bool)) public exercised;
    // Mapping of epoch to bool to strike prices
    mapping(uint256 => mapping(bool => uint256[])) public epochToStrikePrices;
    // Fixed options amount for demo purposes
    uint256 public constant OPTIONS_AMOUNT = 1000;

    // SAMPLE HISTORICAL PRICES
    uint256[7] public prices;

    constructor(
        AggregatorV3Interface _nftFeed,
        IBB20 _nftToken,
        address _controller,
        address _bluebirdManager,
        IOptionPricing _optionsPricing,
        address _owner
    ) {
        // Price feed of NFT
        nftFeed = _nftFeed;
        nftToken = IERC20(_nftToken);
        bluebirdManager = IBluebirdManager(_bluebirdManager);
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

        startTimeEpoch = block.timestamp;
        // Transfer ownership to owner
        transferOwnership(_owner);
    }

    // Admin Functions

    // Set liquidity providing time
    // TODO: Add Natspec
    function setLiquidityProvidingTime(
        uint256 _liquidityProvidingTime
    ) external onlyOwner {
        liquidityProvidingTime = _liquidityProvidingTime;
    }

    // Set expiry
    // TODO: Add Natspec
    function setExpiry(uint256 _expiry) external onlyOwner {
        EXPIRY = _expiry;
    }

    // Internal functions
    // TODO: Add Natspec
    function _calculateStrikePrices(
        uint256 _floorPrice,
        bool _isPut
    ) internal pure returns (uint256[] memory) {
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

    // Function to start an epoch
    // TODO: Add Natspec
    function _startEpoch() internal {
        require(
            block.timestamp > (startTimeEpoch + liquidityProvidingTime),
            "Liquidity providing time has ended"
        );
        startTimeEpoch = block.timestamp;
        epochEnded = false;
        console.log("Epoch started");
    }

    /**
     * @notice Writes options
     * @dev Write during construction of contract
     */
    function writeOption() public {
        // Require that current epoch has not ended
        require(epochEnded == true, "Not time yet to write option");
        // Initialise start time of buying options
        startTimeBuy = block.timestamp;

        // Get floor price of NFT
        uint256 nftPrice = getNftPrice();
        // Get token price of fractionalised NFT
        uint256 nftTokenPrice = nftPrice / 1000000;

        // Get strike prices of call and put options
        uint256[] memory _strikePricesCall = _calculateStrikePrices(
            nftTokenPrice,
            false
        );
        uint256[] memory _strikePricesPut = _calculateStrikePrices(
            nftTokenPrice,
            true
        );

        uint256 _start = block.timestamp;
        // Empty address array to track buyers of options
        address[] memory empty;
        // Determine amount to write based on amount of NFT tokens to write call options
        uint256 amountToWriteCall = maxBuyCall / 3; // TODO: @junmtan why 3
        // Determine amount to write based on amount of ETH to write put options
        uint256 amountToWritePut = maxBuyPut / 3; // TODO: @junmtan why 3
        // Loop through strike prices and write options
        for (uint i = 0; i < _strikePricesCall.length; i++) {
            // Write call options
            nftOpts[currentId] = Option(
                _strikePricesCall[i],
                _start + EXPIRY,
                amountToWriteCall,
                currentId,
                false,
                empty
            );

            // Write put options
            nftOpts[currentId + 1] = Option(
                _strikePricesPut[i],
                _start + EXPIRY,
                amountToWritePut,
                currentId + 1,
                true,
                empty
            );
            console.log("Strike price Call: ", _strikePricesCall[i]);
            console.log("Call option Id: ", currentId);
            console.log("Strike price Put: ", _strikePricesPut[i]);
            console.log("Put option Id: ", currentId + 1);
            // Increment current id
            currentId += 2;

            // Emit events for individual strike prices
            bluebirdManager.emitCallOptionCreatedEvent(
                address(this),
                currentId,
                epoch,
                address(nftToken),
                _strikePricesCall[i],
                _start,
                _start + EXPIRY
            );
            bluebirdManager.emitPutOptionCreatedEvent(
                address(this),
                currentId + 1,
                epoch,
                address(nftToken),
                _strikePricesCall[i],
                _start,
                _start + EXPIRY
            );
        }
        // Increment epoch
        epoch += 1;
        // Save strike prices
        epochToStrikePrices[epoch][false] = _strikePricesCall;
        epochToStrikePrices[epoch][true] = _strikePricesPut;
        _startEpoch();
        // Emit events for epoch
    }

    // View functions

    /**
     * @notice Get premium of an option
     * @param _id Id of contract
     */
    function getPremium(uint256 _id) public view returns (uint256) {
        // Get price of NFT
        uint256 _nftPrice = getNftPrice();
        // Get price of NFT token
        uint256 _nftTokenPrice = _nftPrice / 1000000;
        uint256 _baseIv = BluebirdMath.computeStandardDeviation(prices);
        return
            optionPricing.getOptionPrice(
                nftOpts[_id].isPut,
                nftOpts[_id].expiry,
                nftOpts[_id].strike,
                _nftTokenPrice,
                _baseIv
            );
    }

    //Returns the latest Nft price
    function getNftPrice() public view returns (uint) {
        (, int price, , , ) = nftFeed.latestRoundData();
        //Price should never be negative thus cast int to unit is ok
        //Price is 8 decimal places and will require 1e10 correction later to 18 places
        return uint(price);
    }

    function getStrikes(
        uint256 _epoch,
        bool _isPut
    ) external view returns (uint256[] memory) {
        return epochToStrikePrices[_epoch][_isPut];
    }

    /**
     * @notice Calculate PnL for an option holder
     * @param isPut is put option
     * @param exercisePrice strike price of the option
     * @param numOptions number of options
     * @param spotPrice spot price of the underlying asset at the time of exercise
     */
    // TODO: @junmtan unused function
    function calculatePnL( 
        bool isPut,
        int256 exercisePrice,
        int256 numOptions,
        int256 spotPrice
    ) public pure returns (int256) {
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

        return pnl;
    }

    // Liquidity providing functions

    function depositNftToken(uint amount) public nonReentrant {
        // Require that it is only during liquidity providing time
        require(
            block.timestamp < (startTimeEpoch + liquidityProvidingTime),
            "Liquidity providing time has ended"
        );
        // Take NFT tokens
        require(
            nftToken.transferFrom(msg.sender, address(this), amount),
            "Incorrect amount of NFT Token sent"
        );
        maxBuyCall += amount;
        userDeposits[msg.sender][0] += amount;
    }

    // Deposit eth function
    function depositETH() public payable nonReentrant {
        require(
            block.timestamp < (startTimeEpoch + liquidityProvidingTime),
            "Liquidity providing time has ended"
        );
        // Take ETH from user
        require(msg.value > 0, "Incorrect amount of ETH sent");
        maxBuyPut += msg.value;
        userDeposits[msg.sender][1] += msg.value;
    }

    /**
     * @notice Buy an option based on `_id`
     * @param _id Index of the option
     * @param _getPremium Maximum premium to pay for the option // TODO: @junmtan If premium paid is always lower during purchase, there is no need for this
     */
    function buy(
        uint256 _id,
        uint256 _getPremium
    ) external payable nonReentrant {
        require(
            nftOpts[_id].expiry > block.timestamp,
            "Option is expired and cannot be bought"
        );
        // Buy amount is equal to 2/5 of the total amount of options
        // TODO: @junmtan why are we hardcoding the number of options bought?
        uint256 _amount = nftOpts[_id].amount / 5;
        console.log("Amount of options to buy: ", _amount / 1 ether);
        console.log("Max buy for call options: ", maxBuyCall / 1 ether);
        bool _isPut = nftOpts[_id].isPut;

        // Set max buy
        if (_isPut) {
            require(_amount <= maxBuyPut, "Amount exceeds max buy");
            maxBuyPut -= _amount;
        } else {
            require(_amount <= maxBuyCall, "Amount exceeds max buy");

            maxBuyCall -= _amount;
        }
        // Get price of NFT
        uint256 nftTokenPrice = getNftPrice() / 1000000;
        // Get expiry of option
        uint256 _expiry = nftOpts[_id].expiry;
        // Initialise premium
        uint256 _premium;
        // Get base IV
        uint256 _baseIv = BluebirdMath.computeStandardDeviation(prices);
        // Get isPut

        // Get strike
        uint256 _strike = nftOpts[_id].strike;
        // Get premium based on option type
        if (_isPut) {
            _premium = optionPricing.getOptionPrice(
                true,
                _expiry,
                _strike,
                nftTokenPrice,
                _baseIv
            );
        } else {
            _premium = optionPricing.getOptionPrice(
                false,
                _expiry,
                _strike,
                nftTokenPrice,
                _baseIv
            );
        }

        console.log("Premium: ", _premium);
        // If premium is not within 1% of view premium, revert
        require(
            _premium >= _getPremium - (_getPremium / 100),
            "Premium is not within 1% of view premium"
        );
        // Record amount of options bought by user
        userToOptionIdToAmount[msg.sender][_id] += _amount / 1 ether;
        //Transfer premium payment from buyer to protocol
        uint256 _amountTokens = _premium / nftTokenPrice;
        console.log("NFT token price: ", nftTokenPrice);
        console.log("Amount of tokens to transfer: ", _amountTokens);
        require(
            nftToken.transferFrom(msg.sender, address(this), _amountTokens),
            "Premium payment failed"
        );

        // Add buyer to list of buyers
        nftOpts[_id].buyers.push(msg.sender);

        // Emit event
        bluebirdManager.emitBoughtEvent(
            address(this),
            msg.sender,
            _id,
            _amount,
            _premium,
            block.timestamp,
            epoch
        );
    }
    // TODO: Add natspec
    function calculateAmountETH(uint256 _id) public view returns (uint256) {
        return nftOpts[_id].strike * userToOptionIdToAmount[msg.sender][_id];
    }

    /**
     * @notice Exercise an option based on `_id`
     * @param _id Id of option to exercise
     */
    function exercise(uint256 _id) external payable {
        require(
            userToOptionIdToAmount[msg.sender][_id] > 0,
            "You do not own this option"
        );
        require(
            !exercised[msg.sender][_id],
            "Option has already been exercised"
        );
        require(nftOpts[_id].expiry < block.timestamp, "Option is not expired");
        uint256 nftTokenPrice = getNftPrice() / 1000000;
        uint256 _amountETH;
        bool _profit;
        // Calculate pnl
        if (!nftOpts[_id].isPut) {
            if (nftTokenPrice > nftOpts[_id].strike) {
                _profit = true;
                // Call buyers pay strike price * amount to protocol
                _amountETH = calculateAmountETH(_id);
                console.log(
                    "Amount of ETH to send to protocol: %s",
                    _amountETH
                );
                require(
                    msg.value == _amountETH,
                    "Incorrect amount of ETH sent to buy NFT Token"
                );
                // Transfer from protocol to user NFT token
                require(
                    nftToken.transfer(
                        msg.sender,
                        userToOptionIdToAmount[msg.sender][_id] * 1 ether
                    ),
                    "Insufficient amount of NFT Token sent to user"
                );
            }
        } else {
            if (nftTokenPrice < nftOpts[_id].strike) {
                _profit = true;
                // Put buyers pay strike price * amount to protocol
                _amountETH = calculateAmountETH(_id);
                // Transfer from user to protocol amount of token
                require(
                    nftToken.transferFrom(
                        msg.sender,
                        address(this),
                        userToOptionIdToAmount[msg.sender][_id] * 1 ether
                    ),
                    "Insufficient amount of NFT Token sent to protocol"
                );
                // Transfer from protocol to user eth
                (bool success, ) = payable(msg.sender).call{value: _amountETH}(
                    ""
                );
                require(success, "Insufficient amount of ETH sent to user");
            }
        }
        exercised[msg.sender][_id] = true;
        // Emit event
        bluebirdManager.emitExerciseEvent(
            address(this),
            msg.sender,
            _id,
            _amountETH,
            _profit
        );
    }

}