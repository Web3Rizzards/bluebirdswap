// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/IBluebirdManager.sol";
import "./BluebirdOptions.sol";
import "./BB20.sol";
import "./interfaces/IBluebirdGrinder.sol";
import "./utils/SetUtils.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/// @title BluebirdManager - Manager contracts for Bluebird Options individual contracts

contract BluebirdManager is IBluebirdManager, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using SetUtils for EnumerableSet.AddressSet;
    /**
     * @notice Array of all options contract addresses
     */
    EnumerableSet.AddressSet internal optArray;

    /**
     * @notice Option Pricing Contract
     */
    IOptionPricing public optionPricing;

    /**
     * @notice Bluebird Grinder Contract
     */
    IBluebirdGrinder public grinder;

    /**
     * @notice Mapping of NFT token address to boolean to check if options have been created
     */
    mapping(address => bool) public optionExists;

    /**
     * @notice Constructor for Bluebird Manager
     * @param _optionPricing Option Pricing Contract
     * @param _grinder Bluebird Grinder Contract
     */
    constructor(IOptionPricing _optionPricing, IBluebirdGrinder _grinder) {
        optionPricing = _optionPricing;
        grinder = _grinder;
    }

    /**
     * @notice Modifier to check if msg.sender is an Options Contract
     */
    modifier onlyOptions() {
        require(
            optArray.contains(msg.sender) || msg.sender == address(this),
            "Only Options Contract can call this function"
        );
        _;
    }

    /**
     * @notice Create a Put and Call Options for a specified collection for the current epoch
     * @param _collectionAddress Collection Address
     * @param _nftFeedAddress Chainlink Feed Address
     */
    function createOptions(address _collectionAddress, address _nftFeedAddress) public onlyOwner {
        // Check if BB20 token was created
        IBB20 _nftToken = grinder.getTokenFromCollection(_collectionAddress);

        // If BB20 token was not created, create it
        require(address(_nftToken) != address(0), "NFT Token not created");
        require(optionExists[address(_nftToken)] == false, "Options already created for this NFT");

        // Get current floor price of NFT from Chainlink
        AggregatorV3Interface _nftFeed = AggregatorV3Interface(_nftFeedAddress);

        // Create new Options
        BluebirdOptions opt = new BluebirdOptions(_nftFeed, _nftToken, address(this), optionPricing, msg.sender);

        // Add nft collection options contract to array
        optArray.add(address(opt));

        // Set optionExists to true
        optionExists[address(_nftToken)] = true;

        // Emit event
        emit OptionContractCreated(address(opt), address(_collectionAddress), address(_nftToken));
    }

    /**
     * @notice Function to retrieve options array
     */
    function getOptArray() external view returns (address[] memory) {
        return optArray.toArray();
    }

    /**
     * @notice Proxy function to emit event from options contract
     * @param _contractAddress Address of options contract
     * @param _optionId Option ID
     * @param _epoch Epoch
     * @param _nftToken NFT Token Address
     * @param _strikePrice Strike Price
     * @param _start Start Time
     * @param _expiry Expiry Time
     */
    function emitCallOptionCreatedEvent(
        address _contractAddress,
        uint256 _optionId,
        uint256 _epoch,
        address _nftToken,
        uint256 _strikePrice,
        uint256 _start,
        uint256 _expiry
    ) external onlyOptions {
        emit CallOptionCreated(_contractAddress, _optionId, _epoch, _nftToken, _strikePrice, _start, _expiry);
    }

    /**
     * @notice Proxy function to emit event from options contract
     * @param _contractAddress Address of options contract
     * @param _optionId Option ID
     * @param _epoch Epoch
     * @param _nftToken NFT Token Address
     * @param _strikePrice Strike Price
     * @param _start Start Time
     * @param _expiry Expiry Time
     */
    function emitPutOptionCreatedEvent(
        address _contractAddress,
        uint256 _optionId,
        uint256 _epoch,
        address _nftToken,
        uint256 _strikePrice,
        uint256 _start,
        uint256 _expiry
    ) external onlyOptions {
        emit PutOptionCreated(_contractAddress, _optionId, _epoch, _nftToken, _strikePrice, _start, _expiry);
    }

    /**
     * @notice Proxy function to emit event from options contract
     * @param _contractAddress Address of options contract
     * @param _user User Address
     * @param _order Order ID
     * @param _amount Amount
     * @param _premium Premium
     * @param _timestamp Timestamp
     * @param _epoch Epoch
     */
    function emitBoughtEvent(
        address _contractAddress,
        address _user,
        uint256 _order,
        uint256 _amount,
        uint256 _premium,
        uint256 _timestamp,
        uint256 _epoch
    ) external onlyOptions {
        emit Bought(_contractAddress, _user, _order, _amount, _premium, _timestamp, _epoch);
    }

    /**
     * @notice Proxy function to emit event from options contract
     * @param _contractAddress Address of options contract
     * @param _user User Address
     * @param _id Order ID
     * @param _pnl PnL
     * @param _profit Profit
     */
    function emitExerciseEvent(
        address _contractAddress,
        address _user,
        uint256 _id,
        uint256 _pnl,
        bool _profit
    ) external onlyOptions {
        emit Exercised(_contractAddress, _user, _id, _pnl, _profit);
    }
}
