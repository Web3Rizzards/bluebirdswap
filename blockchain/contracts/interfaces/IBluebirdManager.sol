// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title IBluebird Manager
/// @notice The Bluebird Options Manager
interface IBluebirdManager {
    /**
     * @notice Emit when Call Option Contract is Created
     * @param _contractAddress Address of the contract created
     * @param _nftFeed Address of the NFT Oracle Feed from Chainlink
     * @param epoch Epoch of the option
     * @param _strikePrices Fixed strike prices
     * @param _start Start time of epoch
     * @param _expiry End time of epoch
     */
    event CallOptionCreated(
        address indexed _contractAddress,
        address indexed _nftFeed,
        address indexed _nftToken,
        uint256 epoch,
        uint256[] _strikePrices,
        uint256 _start,
        uint256 _expiry
    );

    /**
     * @notice Emit when ut option contract is Created
     * @param _contractAddress Address of the contract created
     * @param _nftFeed Address of the NFT Oracle Feed from Chainlink
     * @param epoch Epoch of the option
     * @param _strikePrices Fixed strike prices
     * @param _start Start time of epoch
     * @param _expiry End time of epoch
     */
    event PutOptionCreated(
        address indexed _contractAddress,
        address indexed _nftFeed,
        address indexed _nftToken,
        uint256 epoch,
        uint256[] _strikePrices,
        uint256 _start,
        uint256 _expiry
    );

    /**
     * @notice Emitted when an option is bought
     * @param _user User's address
     * @param _order Order Index
     * @param _amount Lots purchased
     * @param _strikePrice Strike price of purchase
     * @param _premium Premium paid
     * @param _isPut Is the option a put option
     * @param _timestamp Timestamp of purchase
     * @param _epoch Epoch of the option
     * @param _nftToken Address of the NFT Token
     */
    event Bought(address indexed _user, uint256 indexed _order, uint256 _amount, uint256 _strikePrice, uint256 _premium, bool _isPut, uint256 _timestamp, uint256 _epoch, address _nftToken);


    /**
     * @notice Emitted when a user claims profits
     * @param _user User's address
     * @param _order Order Index
     * @param _profits User's profits
     */
    event Claimed(address indexed _user, uint256 indexed _order, uint256 _profits);

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
        address _nftFeed,
        address _nftToken,
        uint256 epoch,
        uint256[] memory _strikePrices,
        uint256 _start,
        uint256 _expiry
    ) external;

    function emitPutOptionCreatedEvent(
        address _contractAddress,
        address _nftFeed,
        address _nftToken,
        uint256 epoch,
        uint256[] memory _strikePrices,
        uint256 _start,
        uint256 _expiry
    ) external;

    function emitBoughtEvent(
        address _user,
        uint256 _order,
        uint256 _amount,
        uint256 _strikePrice,
        uint256 _premium,
        bool _isPut,
        uint256 _timestamp,
        uint256 _epoch,
        address _nftToken
    ) external;

    function emitClaimedEvent(address _user, uint256 _order, uint256 _profits) external;
}
