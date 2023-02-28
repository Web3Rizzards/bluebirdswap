// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;


import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./interfaces/IBluebirdFactory.sol";
import "./BluebirdOptions.sol";
import "./BB20.sol";
import "./interfaces/IBluebirdGrinder.sol";

// TODO: Make contract compile

contract BluebirdFactory is IBluebirdFactory, Ownable {
    BluebirdOptions[] public optArray;
    IOptionPricing public optionPricing;
    IBluebirdGrinder public grinder;

    uint256 public constant FRACTIONALISED_AMOUNT = 1000000; //TODO: change to 1,000,000 ethers
    address public controller;

    constructor(
        IOptionPricing _optionPricing,
        address _controller,
        IBluebirdGrinder _grinder
    ) {
        optionPricing = _optionPricing;
        controller = _controller;
        grinder = _grinder;
    }

    /**
     * @notice Create a Put and Call Options for a specified collection for the current epoch
     * @param _collectionAddress Collection Address
     */
    function createOptions(address _collectionAddress) public onlyOwner {
        // Check if BB20 token was created
        address _nftToken = address(
            grinder.getTokenFromCollection(_collectionAddress)
        );
        require(_nftToken != address(0), "NFT Token not created");

        // Get current floor price of NFT from Chainlink
        AggregatorV3Interface _nftFeed = AggregatorV3Interface(
            _collectionAddress
        );
        (
            uint80 roundID,
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = _nftFeed.latestRoundData();

        // TODO: Get Strike Prices for Call option based on current floor price
        // uint256[3] memory =  _getCallStrikePrices();

        // Create new Call Options
        BluebirdOptions call = new BluebirdOptions(
            _nftFeed,
            _nftToken,
            controller,
            optionPricing
        );

        // TODO: Get Strike Prices for Put option based on current floor price
        // uint256[3] memory =  _getPutStrikePrices();

        // Create new Put Options

        // TODO: Emit event
    }

    // TODO:
    function getEpoch(address _collectionAddress) external view override {}
}
