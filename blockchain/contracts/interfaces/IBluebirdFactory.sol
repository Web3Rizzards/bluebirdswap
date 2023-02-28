// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;


/// @title IBluebird Factory 
/// @notice The Bluebird Options Factory will be creating 'Call' and 'Put' Options contract every epoch
interface IBluebirdFactory {

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
     * @notice Create a New Call and Put Options for the epoch
     * @param _collectionAddress Address of the NFT Collection
     * @dev Can only create when previous epoch has expired
     * @dev Increment epoch
     * @dev Must be whitelisted NFT collection
     */
    function createOptions(address _collectionAddress) external;

    /**
     * @notice Get current epoch for specified collection address
     * @param _collectionAddress Collection address
     */
    function getEpoch(address _collectionAddress) external view;


    
}