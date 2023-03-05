// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./utils/SetUtils.sol";
import "./interfaces/IBluebirdGrinder.sol";
import { BB20 } from "./BB20.sol";

/// @title BluebirdGrinder - Contract to fractionalize NFTs into BB20 tokens

contract BluebirdGrinder is IBluebirdGrinder, Ownable {
    using EnumerableSet for EnumerableSet.UintSet;
    using SetUtils for EnumerableSet.UintSet;
    /**
     * @notice Amount of BB20 tokens to mint per NFT
     * @dev 1 NFT = 1 million BB20 tokens
     */
    uint256 public constant FRACTIONALISED_AMOUNT = 1000000 ether;

    /**
     * @notice Mapping of collection address to enumerable token Ids
     */
    mapping(address => EnumerableSet.UintSet) internal collectionToTokenIds;

    /**
     * @notice Mapping of NFT collection address to BB20 token address
     */
    mapping(address => BB20) public nftAddressToTokenAddress;

    /**
     * @notice Mapping of collection address to boolean to check if collection is whitelisted
     */
    mapping(address => bool) public whitelisted;

    constructor() {}

    /**
     * @notice Function to fractionalize NFTs into BB20 tokens
     * @param _collectionAddress Address of NFT collection
     * @param _tokenId Token Id of NFT to fractionalize
     */
    function fractionalizeNFT(address _collectionAddress, uint256 _tokenId) external override {
        require(_collectionAddress != address(0), "Invalid collection address");
        require(whitelisted[_collectionAddress], "Collection not whitelisted");
        // Require transfer of NFT to this contract
        IERC721Metadata(_collectionAddress).transferFrom(msg.sender, address(this), _tokenId);

        // Add token id to enumerable set
        EnumerableSet.add(collectionToTokenIds[_collectionAddress], _tokenId);
        BB20 nftToken;
        if (nftAddressToTokenAddress[_collectionAddress] == BB20(address(0))) {
            string memory _name = concatenate("BB Fractionalized ", IERC721Metadata(_collectionAddress).name());
            string memory _symbol = concatenate("bb", IERC721Metadata(_collectionAddress).symbol());
            // Create new BB20 contract
            nftToken = new BB20(_name, _symbol, address(this));
            nftAddressToTokenAddress[_collectionAddress] = nftToken;
        } else {
            nftToken = nftAddressToTokenAddress[_collectionAddress];
        }

        // Mint 1 million tokens to msg.sender
        nftToken.mint(msg.sender, FRACTIONALISED_AMOUNT);
        // Emit event
        emit Fractionalised(_collectionAddress, address(nftToken), _tokenId, msg.sender);
    }

    /**
     * @notice Function to reconstruct NFTs from BB20 tokens
     * @param _collectionAddress Address of NFT collection
     * @param _tokenId Token Id of NFT to reconstruct
     */
    function reconstructNFT(address _collectionAddress, uint256 _tokenId) external override {
        require(_collectionAddress != address(0), "Invalid collection address");
        // Require tokenId exists in enumerable set
        require(EnumerableSet.contains(collectionToTokenIds[_collectionAddress], _tokenId), "Token id does not exist");
        // Require transfer of 1 million equivalent tokens to this contract
        require(
            IERC20(nftAddressToTokenAddress[_collectionAddress]).transferFrom(
                msg.sender,
                address(this),
                FRACTIONALISED_AMOUNT
            ),
            "Transfer failed"
        );
        // Burn all the tokens
        nftAddressToTokenAddress[_collectionAddress].burn(FRACTIONALISED_AMOUNT);
        // Remove token id from enumerable set
        EnumerableSet.contains(collectionToTokenIds[_collectionAddress], _tokenId);
        // Transfer NFT to msg.sender
        IERC721(_collectionAddress).transferFrom(address(this), msg.sender, _tokenId);
        // Emit event
        emit Redeemed(_collectionAddress, _tokenId, msg.sender);
    }

    /**
     * @notice Function to whitelist NFT collection
     * @param _collectionAddress Address of NFT collection
     */
    function whitelistNFT(address _collectionAddress) external override onlyOwner {
        whitelisted[_collectionAddress] = true;
    }

    /**
     * @notice Function to get token address from collection address
     * @param _collectionAddress Address of NFT collection
     */
    function getTokenFromCollection(address _collectionAddress) external view override returns (IBB20) {
        return nftAddressToTokenAddress[_collectionAddress];
    }

    /**
     * @notice Function to get all token ids from collection address that are in the contract
     * @param _collectionAddress Address of NFT collection
     */
    function getIds(address _collectionAddress) external view returns (uint256[] memory) {
        return collectionToTokenIds[_collectionAddress].toArray();
    }

    /**
     * @notice Returns a concatenated string of a and b
     * @param _a string a
     * @param _b string b
     */
    function concatenate(string memory _a, string memory _b) internal pure returns (string memory) {
        return string(abi.encodePacked(_a, _b));
    }
}
