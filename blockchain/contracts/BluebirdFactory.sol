// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./BluebirdCallOptions.sol";
import "./BluebirdPutOptions.sol";
import "./NFTToken.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract BluebirdFactory is Ownable {
  BluebirdCallOptions[] public callArray;
  BluebirdPutOptions[] public putArray;
  NFTToken[] public nftTokenArray;
  // Mapping of collection address to enumerable token Ids
  mapping(address => EnumerableSet.UintSet) internal collectionToTokenIds;
  mapping(address => address) public nftAddressToTokenAddress;
  uint256 public constant FRACTIONALISED_AMOUNT = 1000000;

   // Events
  event CallCreated(address indexed _callAddress, address indexed _nftFeed, address indexed _nftToken, uint256[] _strikePrices, uint256 _premium, uint256 _expiry);
  event PutCreated(address indexed _putAddress, address indexed _nftFeed, address indexed _nftToken, uint256[] _strikePrices, uint256 _premium, uint256 _expiry);
  event NFTTokenCreated(address indexed _nftTokenAddress, address indexed _collectionAddress, string _name, string _symbol);
  event Fractionalised(address indexed _collectionAddress, uint256 _tokenId, address indexed _nftTokenAddress);
  event Redeemed(address indexed _collectionAddress, uint256 _tokenId, address indexed _nftTokenAddress, address indexed _to, uint256 _amount);

   function createNewCall(address _nftFeed, address _nftToken, uint256[] calldata _strikePrices, uint256 _premium, uint256 _expiry) public onlyOwner{
     BluebirdCallOptions call = new BluebirdCallOptions(_nftFeed, _nftToken, _strikePrices, _premium, _expiry);
     callArray.push(call);
   }

   function createNewPut(address _nftFeed, address _nftToken, uint256[] calldata _strikePrices, uint256 _premium, uint256 _expir) public onlyOwner{
     BluebirdPutOptions put = new BluebirdPutOptions(_nftFeed, _nftToken, _strikePrices, _premium, _expir);
     putArray.push(put);
   }

   function fractionalise(address _collectionAddress, uint256 _tokenId) external {
      require(_collectionAddress != address(0), "Invalid collection address");
      // Require transfer of NFT to this contract
      require(IERC721(_collectionAddress).transferFrom(msg.sender, address(this), _tokenId), "Transfer failed");
      // Add token id to enumerable set
      collectionToTokenIds[_collectionAddress].add(_tokenId);
      string memory _name = IERC721(_collectionAddress).name();
      string memory _symbol = IERC721(_collectionAddress).symbol();
      // Create new NFTToken contract
      NFTToken nftToken = new NFTToken(_name, _symbol, address(this));
      nftTokenArray.push(nftToken);
      // Map collection address to NFTToken address
      nftAddressToTokenAddress[_collectionAddress] = address(nftToken);
      // Mint 1 million tokens to msg.sender
      nftToken.mint(msg.sender, FRACTIONALISED_AMOUNT);
      // Emit event
      emit Fractionalised(_collectionAddress, _tokenId, address(nftToken));
   }

   function redeem(address _collectionAddress, uint256 _tokenId) external {
      require(_collectionAddress != address(0), "Invalid collection address");
      // Require tokenId exists in enumerable set
      require(collectionToTokenIds[_collectionAddress].contains(_tokenId), "Token id does not exist");
      // Require transfer of 1 million equivalent tokens to this contract
      require(IERC20(nftAddressToTokenAddress[_collectionAddress]).transferFrom(msg.sender, address(this), FRACTIONALISED_AMOUNT), "Transfer failed");
      // Burn all the tokens
      IERC20(nftAddressToTokenAddress[_collectionAddress]).burn(FRACTIONALISED_AMOUNT);
      // Remove token id from enumerable set
      collectionToTokenIds[_collectionAddress].remove(_tokenId);
      // Transfer NFT to msg.sender
      IERC721(_collectionAddress).transferFrom(address(this), msg.sender, _tokenId);
      // Emit event
      emit Redeemed(_collectionAddress, _tokenId, nftAddressToTokenAddress[_collectionAddress], msg.sender, FRACTIONALISED_AMOUNT);

   }

}