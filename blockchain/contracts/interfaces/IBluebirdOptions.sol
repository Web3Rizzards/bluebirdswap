// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title IBluebirdOptions 
/// @notice The Bluebird Options contract will represent a options belonging to an epoch.
/// @notice The contract will contain the strike prices for the epoch
/// @notice The contract will only encapsulate puts or calls only
/// @notice The contract shall be named as {NFT_SYMBOL}-{EPOCH}-{PUT/CALL}
interface IBluebirdOptions {

    /**
     * @notice Emitted when an option is bought
     * @param _user User's address
     * @param _order Order Index
     * @param _amount Lots purchased
     * @param _strikePrice Strike price of purchase
     * @param _premium Premium paid
     */
    event Bought(address indexed _user, uint256 indexed _order, uint256 _amount, uint256 _strikePrice, uint256 _premium);


    /**
     * @notice Emitted when a user claims profits
     * @param _user User's address
     * @param _order Order Index
     * @param _profits User's profits
     */
    event Claimed(address indexed _user, uint256 indexed _order, uint256 _profits);

    /**
     * @notice Buy an option
     * @param _strikeIndex Index of the strike price
     * @param _amount amount of lots to buy
     * @dev Option must have started
     * @dev Option must not have expired
     * @dev `_amount` must be less than or equal to the amount of lots available
     */
    function buy(uint8 _strikeIndex, uint256 _amount) external;

    /**
     * @notice Claim profits, if any
     * @param _orderIndex Order Index
     * @dev Must be owner of order
     */
    function exercise(uint256 _orderIndex) external;

    /**
     * @notice Get strike prices of the current contract    
     */
    function getStrikes() external view returns (uint256[] memory);

    /**
     * @notice Get premium based on strike price (derived from _strikeIndex)   
     */
    function getPremium(uint256 _strikeIndex) external view returns (uint256);
}