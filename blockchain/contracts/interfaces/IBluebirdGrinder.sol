// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;


/// @title IBluebird Grinder 
/// @notice The Bluebird Grinder will break down an NFT into shards
interface IBluebirdGrinder {

    event Redeemed(
        address indexed _collectionAddress,
        uint256 _tokenId,
        address indexed _nftTokenAddress,
        address indexed _to,
        uint256 _amount
    );
    
    event Fractionalised(address indexed _collectionAddress, uint256 _tokenId, address indexed _nftTokenAddress);
    /// @notice Convert 1 ERC721 Token into X amount of bb{NFT} ERC20 tokens
    function fractionalizeNFT(address _collectionAddress, uint256 _tokenId) external;



    /// @notice Whitelist NFT
    function whitelistNFT(address _collectionAddress) external;
    
}