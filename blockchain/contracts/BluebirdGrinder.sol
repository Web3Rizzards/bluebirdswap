// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "./interfaces/IBluebirdGrinder.sol";
import {BB20} from "./BB20.sol";

// TODO: Make contract compile


contract BluebirdGrinder is IBluebirdGrinder, Ownable {
    // 1 NFT = 1 million BB20 tokens
    uint256 public constant FRACTIONALISED_AMOUNT = 1000000 ether;

    // Mapping of collection address to enumerable token Ids
    mapping(address => EnumerableSet.UintSet) internal collectionToTokenIds;
    mapping(address => BB20) public nftAddressToTokenAddress;

    constructor() {}


    function fractionalizeNFT(
        address _collectionAddress,
        uint256 _tokenId
    ) external override {
        require(_collectionAddress != address(0), "Invalid collection address");
        // Require transfer of NFT to this contract
        IERC721Metadata(_collectionAddress).transferFrom(msg.sender, address(this), _tokenId);
        
        // Add token id to enumerable set
        EnumerableSet.add(collectionToTokenIds[_collectionAddress], _tokenId);

        string memory _name = concatenate(
            "BB Fractionalized ",
            IERC721Metadata(_collectionAddress).name()
        );
        string memory _symbol = concatenate(
            "bb",
            IERC721Metadata(_collectionAddress).symbol()
        );
        // Create new BB20 contract
        BB20 nftToken = new BB20(_name, _symbol, address(this));

        // Map collection address to BB20 address
        nftAddressToTokenAddress[_collectionAddress] = nftToken;
        // Mint 1 million tokens to msg.sender
        nftToken.mint(msg.sender, FRACTIONALISED_AMOUNT);
        // Emit event
        emit Fractionalised(_collectionAddress, address(nftToken), _tokenId, msg.sender);
    }

    function reconstructNFT(
        address _collectionAddress,
        uint256 _tokenId
    ) external override {

        require(_collectionAddress != address(0), "Invalid collection address");
        // Require tokenId exists in enumerable set
        require(
            EnumerableSet.contains(collectionToTokenIds[_collectionAddress],_tokenId),
            "Token id does not exist"
        );
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
        nftAddressToTokenAddress[_collectionAddress].burn(
            FRACTIONALISED_AMOUNT
        );
        // Remove token id from enumerable set
        EnumerableSet.contains(collectionToTokenIds[_collectionAddress],_tokenId);
        // Transfer NFT to msg.sender
        IERC721(_collectionAddress).transferFrom(
            address(this),
            msg.sender,
            _tokenId
        );
        // Emit event
        emit Redeemed(
            _collectionAddress,
            _tokenId,
            msg.sender
        );
    }

    function whitelistNFT(address _collectionAddress) external override {}

    function getTokenFromCollection(address _collectionAddress) external view override returns (IBB20) {
        return nftAddressToTokenAddress[_collectionAddress];
    }


    /**
     * @notice Returns a concatenated string of a and b
     * @param _a string a
     * @param _b string b
     */
    function concatenate(
        string memory _a,
        string memory _b
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(_a, _b));
    }
}
