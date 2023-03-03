// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

/// @title IBluebirdOptions
/// @notice The Bluebird Options contract will represent a options belonging to an epoch.
/// @notice The contract will contain the strike prices for the epoch
/// @notice The contract will only encapsulate puts or calls only
/// @notice The contract shall be named as {NFT_SYMBOL}-{EPOCH}-{PUT/CALL}
interface IBluebirdOptions {
    /**
     * @notice Buy an option
     * @param _id ID of the option
     * @param _getPremium premium viewed before buying
     * @dev Option must have started
     * @dev Option must not have expired
     * @dev `_amount` must be less than or equal to the amount of lots available
     */
    function buy(uint256 _id, uint256 _getPremium) external payable;

    /**
     * @notice Claim profits, if any
     * @param _id Order Index
     * @dev Must be owner of order
     */
    function exercise(uint256 _id) external payable;

    /**
     * @notice Get strike prices of the current contract
     * @param _epoch Epoch of the option
     * @param _isPut Is the option a put option
     */
    function getStrikes(uint256 _epoch, bool _isPut) external view returns (uint256[] memory);

    /**
     * @notice Get premium based on option id
     */
    function getPremium(uint256 _id) external view returns (uint256);

}
