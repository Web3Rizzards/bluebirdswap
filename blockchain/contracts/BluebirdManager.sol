// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/IBluebirdManager.sol";
import "./BluebirdOptions.sol";
import "./BB20.sol";
import "./interfaces/IBluebirdGrinder.sol";
import "./utils/SetUtils.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
// import console.log
import "hardhat/console.sol";

contract BluebirdManager is IBluebirdManager, Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using SetUtils for EnumerableSet.AddressSet;
    EnumerableSet.AddressSet internal optArray;
    IOptionPricing public optionPricing;
    IBluebirdGrinder public grinder;

    address public controller;

    constructor(IOptionPricing _optionPricing, address _controller, IBluebirdGrinder _grinder) {
        optionPricing = _optionPricing;
        controller = _controller;
        grinder = _grinder;
    }

    // Modifier to check if caller is options contract
    modifier onlyOptions() {
        console.log("msg.sender: %s", msg.sender);
        console.log("address(this): %s", address(this));
        console.log("optArray.contains(msg.sender): %s", optArray.contains(msg.sender));
        require(
            optArray.contains(msg.sender) || msg.sender == address(this),
            "Only Options Contract can call this function"
        );
        _;
    }

    /**
     * @notice Create a Put and Call Options for a specified collection for the current epoch
     * @param _collectionAddress Collection Address
     */
    function createOptions(address _collectionAddress, address _nftFeedAddress) public onlyOwner {
        // Check if BB20 token was created
        IBB20 _nftToken = grinder.getTokenFromCollection(_collectionAddress);
        require(address(_nftToken) != address(0), "NFT Token not created");

        // Get current floor price of NFT from Chainlink
        AggregatorV3Interface _nftFeed = AggregatorV3Interface(_nftFeedAddress);

        // Create new Options
        BluebirdOptions opt = new BluebirdOptions(_nftFeed, _nftToken, controller, address(this), optionPricing);

        // Add to array
        optArray.add(address(opt));

        IBluebirdOptions(address(opt)).writeOption();
    }

    function getOptArray() external view returns (address[] memory) {
        return optArray.toArray();
    }

    function emitCallOptionCreatedEvent(
        address _contractAddress,
        address _nftFeed,
        address _nftToken,
        uint256 epoch,
        uint256[] memory _strikePrices,
        uint256 _start,
        uint256 _expiry
    ) external onlyOptions {
        emit CallOptionCreated(_contractAddress, _nftFeed, _nftToken, epoch, _strikePrices, _start, _expiry);
    }

    function emitPutOptionCreatedEvent(
        address _contractAddress,
        address _nftFeed,
        address _nftToken,
        uint256 epoch,
        uint256[] memory _strikePrices,
        uint256 _start,
        uint256 _expiry
    ) external onlyOptions {
        emit PutOptionCreated(_contractAddress, _nftFeed, _nftToken, epoch, _strikePrices, _start, _expiry);
    }

    function emitBoughtEvent(
        address _user,
        uint256 _order,
        uint256 _amount,
        uint256 _strikePrice,
        uint256 _premium,
        bool _isPut,
        uint256 _timestamp,
        uint256 _epoch,
        address _nftToken
    ) external onlyOptions {
        emit Bought(_user, _order, _amount, _strikePrice, _premium, _isPut, _timestamp, _epoch, _nftToken);
    }

    function emitClaimedEvent(address _user, uint256 _order, uint256 _profits) external onlyOptions {
        emit Claimed(_user, _order, _profits);
    }
}
