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

    // Fractionalized NFT token
    IERC20 public nftToken;

    // Bluebird Manager
    IBluebirdManager public bluebirdManager;

    // Option Pricing
    IOptionPricing public optionPricing;

    // Options expiry
    uint256 public EXPIRY = 600;

    // Start time of epoch
    uint256 public startTimeEpoch;

    uint256 public interval = 24;
    // Current epoch
    uint256 public epoch;

    // Time to provide liquidity
    uint256 public liquidityProvidingTime = 5 minutes;

    // Id tracker for each strike price of options
    uint256 public currentId;

    // Max amount of call options that can be bought currently
    uint256 public maxBuyCall;

    // Max amount of put options that can be bought currently
    uint256 public maxBuyPut;

    // Mapping to track liquidity providers' deposits
    mapping(address => mapping(uint256 => uint256)) public userDeposits;

    // Mapping to track each strike price of options
    mapping(uint256 => Option) public nftOpts;

    // Mapping of user to option id to amount bought
    mapping(address => mapping(uint256 => uint256)) public userToOptionIdToAmount;

    // Mapping which checks if current id has been exercised
    mapping(address => mapping(uint256 => bool)) public exercised;
    // Mapping of epoch to isPut to strike prices
    mapping(uint256 => mapping(bool => uint256[])) public epochToStrikePrices;

    constructor(
        AggregatorV3Interface _nftFeed,
        IBB20 _nftToken,
        address _bluebirdManager,
        IOptionPricing _optionsPricing,
        address _owner
    ) {
        // Price feed of NFT
        nftFeed = _nftFeed;
        nftToken = IERC20(_nftToken);
        bluebirdManager = IBluebirdManager(_bluebirdManager);
        optionPricing = IOptionPricing(_optionsPricing);

        // Transfer ownership to owner
        transferOwnership(_owner);
    }

    // Admin Functions

    /**
     * @notice Set liquidity providing time
     * @param _liquidityProvidingTime Time to provide liquidity
     */
    function setLiquidityProvidingTime(uint256 _liquidityProvidingTime) external onlyOwner {
        liquidityProvidingTime = _liquidityProvidingTime;
    }

    /**
     * @notice Set expiry
     * @param _expiry Expiry of options
     */
    function setExpiry(uint256 _expiry) external onlyOwner {
        EXPIRY = _expiry;
    }

    /**
     * @notice Set interval
     * @param _interval interval of chainlink round update
     */
    function setInterval(uint256 _interval) external onlyOwner {
        interval = _interval;
    }

    // Internal functions
    /**
     * @notice Function to calculate strike prices
     * @param _floorPrice Floor price of NFT
     * @param _isPut Whether option is put or call
     */
    function _calculateStrikePrices(uint256 _floorPrice, bool _isPut) internal pure returns (uint256[] memory) {
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

    /**
     * @notice Function to start epoch
     */
    function startEpoch() public {
        require(getStage() == 2, "Epoch has not ended yet");
        startTimeEpoch = block.timestamp;
        // Increment epoch
        epoch += 1;
    }

    /**
     * @notice Writes options
     * @dev Only owner/controller should be able to trigger this
     */
    function writeOption() public onlyOwner {
        require(getStage() == 1, "Liquidity providing time not over yet");

        // Get floor price of NFT
        uint256 nftPrice = getNftPrice();
        // Get token price of fractionalised NFT
        uint256 nftTokenPrice = nftPrice / 1000000;

        // Get strike prices of call and put options
        uint256[] memory _strikePricesCall = _calculateStrikePrices(nftTokenPrice, false);
        uint256[] memory _strikePricesPut = _calculateStrikePrices(nftTokenPrice, true);

        uint256 _start = block.timestamp;

        // Determine amount to write based on amount of NFT tokens to write call options
        uint256 amountToWriteCall = maxBuyCall / 3; // For simplicity's sake, we will write same amount of options for each strike price
        // Determine amount to write based on amount of ETH to write put options
        uint256 amountToWritePut = maxBuyPut / 3;
        // Loop through strike prices and write options
        for (uint i = 0; i < _strikePricesCall.length; i++) {
            // Write call options
            nftOpts[currentId] = Option(_strikePricesCall[i], _start + EXPIRY, amountToWriteCall, false);

            // Write put options
            nftOpts[currentId + 1] = Option(_strikePricesPut[i], _start + EXPIRY, amountToWritePut, true);

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
                _strikePricesPut[i],
                _start,
                _start + EXPIRY
            );

            // Increment current id
            currentId += 2;
        }

        // Save strike prices
        epochToStrikePrices[epoch][false] = _strikePricesCall;
        epochToStrikePrices[epoch][true] = _strikePricesPut;
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
        // Get historical prices of NFT
        uint[] memory _prices = getHistoricalPrices();
        // Get standard deviation of NFT price
        uint256 _baseIv = BluebirdMath.computeStandardDeviation(_prices);

        return
            optionPricing.getOptionPrice(
                nftOpts[_id].isPut,
                nftOpts[_id].expiry,
                nftOpts[_id].strike,
                _nftTokenPrice,
                _baseIv
            );
    }

    /**
     * @notice Returns the price of NFT from oracle
     * @return Price of NFT
     */
    function getNftPrice() public view returns (uint) {
        (, int price, , , ) = nftFeed.latestRoundData();
        //Price should never be negative thus cast int to unit is ok
        //Price is 8 decimal places and will require 1e10 correction later to 18 places
        return uint(price);
    }

    /**
     * @notice Get current stage of contract
     * @return _stage Stage of contract
     */
    function getStage() public view returns (uint256 _stage) {
        if (block.timestamp > startTimeEpoch && block.timestamp < startTimeEpoch + liquidityProvidingTime) {
            // Liquidity providing stage
            _stage = 0;
            console.log("Stage 0");
        } else if (
            block.timestamp > startTimeEpoch + liquidityProvidingTime &&
            block.timestamp < startTimeEpoch + liquidityProvidingTime + EXPIRY
        ) {
            // Buying stage
            _stage = 1;
            console.log("Stage 1");
        } else {
            // Expiry stage
            _stage = 2;
            console.log("Stage 2");
        }
    }

    /**
     * @notice Returns the historical prices of NFT
     * @return historical prices of NFT
     */

    function getHistoricalPrices() public view returns (uint[] memory) {
        // Create new price array of 7 prices
        uint[] memory prices = new uint[](7);
        // Get latest round data
        (uint80 _roundId, int price, , , ) = nftFeed.latestRoundData();
        prices[0] = uint(price);
        // 1 day has 24 rounds, so get past 7 days worth of prices
        for (uint i = 1; i < 7; i++) {
            (, int _price, , , ) = nftFeed.getRoundData(uint80(_roundId - interval * (i)));
            prices[i] = uint(_price);
        }
        return prices;
    }

    /**
     * @notice Returns the strike prices of an epoch
     * @return uint256[] memory Array of strike prices
     */
    function getStrikes(uint256 _epoch, bool _isPut) external view returns (uint256[] memory) {
        return epochToStrikePrices[_epoch][_isPut];
    }

    // Liquidity providing functions

    /**
     * @notice Provide liquidity by depositing NFT tokens
     * @param amount Amount of NFT tokens to deposit
     */
    function depositNftToken(uint amount) public nonReentrant {
        // Require that it is only during liquidity providing time
        require(getStage() == 0, "Liquidity providing time has ended");
        // Take NFT tokens
        require(nftToken.transferFrom(msg.sender, address(this), amount), "Incorrect amount of NFT Token sent");

        // Increase max buy amount
        maxBuyCall += amount;
        userDeposits[msg.sender][0] += amount;
    }

    /**
     * @notice Provide liquidity by depositing ETH
     */
    function depositETH() public payable nonReentrant {
        require(getStage() == 0, "Liquidity providing time has ended");
        // Take ETH from user
        require(msg.value > 0, "Incorrect amount of ETH sent");

        // Increase max buy amount
        maxBuyPut += msg.value;
        userDeposits[msg.sender][1] += msg.value;
    }

    /**
     * @notice Buy an option based on `_id`
     * @param _id Index of the option
     * @param _amount Amount of options to buy
     */
    function buy(uint256 _id, uint256 _amount) external payable nonReentrant {
        require(nftOpts[_id].expiry > block.timestamp, "Option is expired and cannot be bought");
        // Get isPut
        bool _isPut = nftOpts[_id].isPut;

        // Set max buy
        if (_isPut) {
            require(_amount <= maxBuyPut, "Amount exceeds max buy");
            // Reduce max buy
            maxBuyPut -= _amount;
        } else {
            require(_amount <= maxBuyCall, "Amount exceeds max buy");
            // Reduce max buy
            maxBuyCall -= _amount;
        }
        // Get price of NFT
        uint256 nftTokenPrice = getNftPrice() / 1000000;
        // Get expiry of option
        uint256 _expiry = nftOpts[_id].expiry;
        // Initialise premium
        uint256 _premium;
        // Get historical prices
        uint[] memory _prices = getHistoricalPrices();

        // Get base IV
        uint256 _baseIv = BluebirdMath.computeStandardDeviation(_prices);
        // Get isPut

        // Get strike
        uint256 _strike = nftOpts[_id].strike;
        // Get premium based on option type
        if (_isPut) {
            _premium = optionPricing.getOptionPrice(true, _expiry, _strike, nftTokenPrice, _baseIv);
        } else {
            _premium = optionPricing.getOptionPrice(false, _expiry, _strike, nftTokenPrice, _baseIv);
        }

        // Record amount of options bought by user
        userToOptionIdToAmount[msg.sender][_id] += _amount / 1 ether;
        //Transfer premium payment from buyer to protocol
        uint256 _amountTokens = _premium / nftTokenPrice;
        require(nftToken.transferFrom(msg.sender, address(this), _amountTokens), "Premium payment failed");
        // Calculate extra amount of ETH to send to buyer
        uint256 _extraAmount = msg.value - _premium;
        // Send extra amount of ETH to buyer
        if (_extraAmount > 0) {
            (bool success, ) = payable(msg.sender).call{ value: _extraAmount }("");
            require(success, "Insufficient amount of ETH sent to user");
        }

        // Emit event
        bluebirdManager.emitBoughtEvent(address(this), msg.sender, _id, _amount, _premium, block.timestamp, epoch);
    }

    /**
     * @notice Calculate amount of ETH to be received when exercising an option
     * @param _id Index of the option
     * @return Amount of ETH to be received
     */
    function calculateAmountETH(uint256 _id) public view returns (uint256) {
        return nftOpts[_id].strike * userToOptionIdToAmount[msg.sender][_id];
    }

    /**
     * @notice Exercise an option based on `_id`
     * @param _id Id of option to exercise
     */
    function exercise(uint256 _id) external payable {
        require(userToOptionIdToAmount[msg.sender][_id] > 0, "You do not own this option");
        require(!exercised[msg.sender][_id], "Option has already been exercised");
        require(nftOpts[_id].expiry < block.timestamp, "Option is not expired");
        // Get price of NFT token
        uint256 nftTokenPrice = getNftPrice() / 1000000;
        // Initialise amount of ETH to send to protocol or send to user
        uint256 _amountETH;
        // Initialise profit boolean to determine if user has profit
        bool _profit;
        // Calculate pnl
        if (!nftOpts[_id].isPut) {
            if (nftTokenPrice > nftOpts[_id].strike) {
                _profit = true;
                // Call buyers pay strike price * amount to protocol
                _amountETH = calculateAmountETH(_id);
                require(msg.value == _amountETH, "Incorrect amount of ETH sent to buy NFT Token");
                // Transfer from protocol to user NFT token
                require(
                    nftToken.transfer(msg.sender, userToOptionIdToAmount[msg.sender][_id] * 1 ether),
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
                    nftToken.transferFrom(msg.sender, address(this), userToOptionIdToAmount[msg.sender][_id] * 1 ether),
                    "Insufficient amount of NFT Token sent to protocol"
                );
                // Transfer from protocol to user eth
                (bool success, ) = payable(msg.sender).call{ value: _amountETH }("");
                require(success, "Insufficient amount of ETH sent to user");
            }
        }
        exercised[msg.sender][_id] = true;
        // Emit event
        bluebirdManager.emitExerciseEvent(address(this), msg.sender, _id, _amountETH, _profit);
    }
}
