// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title IBluebirdOptions 
/// @notice The Bluebird Options contract will represent a options belonging to an epoch.
/// @notice The contract will contain the strike prices for the epoch
/// @notice The contract will only encapsulate puts or calls only
/// @notice The contract shall be named as {NFT_SYMBOL}-{EPOCH}-{PUT/CALL}
interface IBluebirdOptions {

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
     */
    event Bought(address indexed _user, uint256 indexed _order, uint256 _amount, uint256 _strikePrice, uint256 _premium, bool _isPut);


    /**
     * @notice Emitted when a user claims profits
     * @param _user User's address
     * @param _order Order Index
     * @param _profits User's profits
     */
    event Claimed(address indexed _user, uint256 indexed _order, uint256 _profits);

    /**
     * @notice Buy an option
     * @param _id ID of the option
     * @param _amount amount of lots to buy
     * @param _isPut Is the option a put option
     * @param _getPremium premium viewed before buying
     * @dev Option must have started
     * @dev Option must not have expired
     * @dev `_amount` must be less than or equal to the amount of lots available
     */
    function buy(uint256 _id, uint256 _amount, bool _isPut, uint256 _getPremium ) external;

    /**
     * @notice Claim profits, if any
     * @param _id Order Index
     * @dev Must be owner of order
     */
    function exercise(uint256 _id) external;

    /**
     * @notice Get strike prices of the current contract    
     * @param _epoch Epoch of the option
     */
    function getStrikes(uint256 _epoch) external view returns (uint256[] memory);

    /**
     * @notice Get premium based on option id
     */
    function viewPremium(uint256 _id) external view returns (uint256);
}