// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;


/// @title IBluebird Factory 
/// @notice The Bluebird Options Factory will be creating 'Call' and 'Put' Options contract every epoch
interface IBluebirdFactory {

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