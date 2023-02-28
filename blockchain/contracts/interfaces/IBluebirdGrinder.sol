// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import { IBB20 } from "./IBB20.sol";

/// @title IBluebird Grinder 
/// @notice The Bluebird Grinder will break down an NFT into shards
interface IBluebirdGrinder {

    event Redeemed(
        address indexed _collectionAddress,
        uint256 _tokenId,
        address  _to
    );
    
    event Fractionalised(address indexed _collectionAddress,address indexed _nftTokenAddress, uint256 _tokenId, address  _to);
    /**
     * @notice Convert 1 ERC721 Token into X amount of BB20 Tokens
     * @param _collectionAddress Collection Address
     * @param _tokenId Token Id of collection address
     */
    function fractionalizeNFT(address _collectionAddress, uint256 _tokenId) external;

    /**
     * @notice Convert X amount of BB20 Tokens into 1 ERC721 Token
     * @param _collectionAddress Collection address of the fractionalized NFT
     * @param _tokenId Token ID of choice in the vaule
     */
    function reconstructNFT(address _collectionAddress, uint256 _tokenId) external;


    /**
     * @notice Whitelist NFT Collection
     * @param _collectionAddress Address of the NFT collection to be whitelisted
     */
    function whitelistNFT(address _collectionAddress) external;

    /**
     * @notice Check if BB20 token exists given collection address
     * @param _collectionAddress Address of the NFT collection
     */
    function getTokenFromCollection(address _collectionAddress) external view returns (IBB20);
    
}