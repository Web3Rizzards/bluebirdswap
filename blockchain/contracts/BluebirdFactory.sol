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

contract BluebirdFactory is IBluebirdFactory, Ownable {
    BluebirdOptions[] public optArray;
    IOptionPricing public optionPricing;
    IBluebirdGrinder public grinder;

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
        IBB20 _nftToken = 
            grinder.getTokenFromCollection(_collectionAddress);
        require(address(_nftToken) != address(0), "NFT Token not created");

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


        // Create new Options
        BluebirdOptions opt = new BluebirdOptions(
            _nftFeed,
            _nftToken,
            controller,
            optionPricing
        );

        // Add to array
        optArray.push(opt);

    }

}
