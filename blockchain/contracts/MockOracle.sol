pragma solidity ^0.8.0;

// Import aggregatorv3
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract MockOracle is AggregatorV3Interface{
    int256 public price;
    uint8 public decimals;
    string public description;
    uint256 public version = 1;
    constructor(int256 _price, uint8 _decimals, string memory _description) {
        price = _price;
        decimals = _decimals;
        description = _description;
    }

    function getRoundData(uint80 _roundId)
        public
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (0, price, 0, 0, 0);
    }
    function latestRoundData()
        public
        view
        override
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (0, price, 0, 0, 0);
    }

   
}