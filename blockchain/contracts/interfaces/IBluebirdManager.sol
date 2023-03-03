// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title IBluebird Manager
/// @notice The Bluebird Options Manager
interface IBluebirdManager {
    /**
     * @notice Emit when Call Option Contract is Created
     * @param _contractAddress Address of the contract created
     * @param _optionId Option Id
     * @param _epoch Epoch of the option
     * @param _nftToken Address of the bb20 token
     * @param _strikePrice Strike Price
     * @param _start Start time of epoch
     * @param _expiry End time of epoch
     */
    event CallOptionCreated(
        address indexed _contractAddress,
        uint256 indexed _optionId,
        uint256 _epoch,
        address _nftToken,
        uint256 _strikePrice,
        uint256 _start,
        uint256 _expiry
    );

    /**
     * @notice Emit when Put option contract is Created
     * @param _contractAddress Address of the contract created
     * @param _optionId Option Id
     * @param _epoch Epoch of the option
     * @param _nftToken Address of the bb20 token
     * @param _strikePrice Strike Price
     * @param _start Start time of epoch
     * @param _expiry End time of epoch
     */
    event PutOptionCreated(
        address indexed _contractAddress,
        uint256 indexed _optionId,
        uint256 _epoch,
        address _nftToken,
        uint256 _strikePrice,
        uint256 _start,
        uint256 _expiry
    );

    /**
     * @notice Emitted when an option is bought
     * @param _contractAddress Address of the contract
     * @param _user User's address
     * @param _optionId Option Index
     * @param _amount Lots purchased
     * @param _premium Premium paid
     * @param _timestamp Timestamp of purchase
     * @param _epoch Epoch of the option
     */
    event Bought(
        address indexed _contractAddress,
        address indexed _user,
        uint256 indexed _optionId,
        uint256 _amount,
        uint256 _premium,
        uint256 _timestamp,
        uint256 _epoch
    );
    /**
     * @notice Emitted when a user claims profits
     * @param _contractAddress Address of the contract
     * @param _user User's address
     * @param _id id of option
     * @param _profits profit or loss number
     * @param _profit true for profit and false for loss -> this indicates _pnl is positive or negative
     */
    event Exercised(
        address indexed _contractAddress,
        address indexed _user,
        uint256 indexed _id,
        uint256 _profits,
        bool _profit
    );

    /**
     * @notice Create a New Call and Put Options for the epoch
     * @param _collectionAddress Address of the NFT Collection
     * @param _nftFeedAddress Address of the NFT Oracle Feed from Chainlink
     * @dev Can only create when previous epoch has expired
     * @dev Increment epoch
     * @dev Must be whitelisted NFT collection
     */
    function createOptions(address _collectionAddress, address _nftFeedAddress) external;

    function emitCallOptionCreatedEvent(
        address _contractAddress,
        uint256 _optionId,
        uint256 _epoch,
        address _nftToken,
        uint256 _strikePrice,
        uint256 _start,
        uint256 _expiry
    ) external;

    function emitPutOptionCreatedEvent(
        address _contractAddress,
        uint256 _optionId,
        uint256 _epoch,
        address _nftToken,
        uint256 _strikePrice,
        uint256 _start,
        uint256 _expiry
    ) external;

    function emitBoughtEvent(
        address _contractAddress,
        address _user,
        uint256 _order,
        uint256 _amount,
        uint256 _premium,
        uint256 _timestamp,
        uint256 _epoch
    ) external;

    function emitExerciseEvent(
        address _contractAddress,
        address _user,
        uint256 _id,
        uint256 _pnl,
        bool _profit
    ) external;
}
