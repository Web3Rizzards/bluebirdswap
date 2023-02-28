// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library HistoricalPriceCalculator {
    // Compute the expected price (mean) of the historical prices
    function getExpectedPrice(uint256[] memory prices) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 length = prices.length;

        for (uint256 i = 0; i < length; i++) {
            sum += prices[i];
        }

        return sum / length;
    }

    // Work out the difference between the average price and each price in the series
    function getDifferences(uint256[] memory prices, uint256 expectedPrice) public pure returns (uint256[] memory) {
        uint256 length = prices.length;
        uint256[] memory differences = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            differences[i] = prices[i] - expectedPrice;
        }

        return differences;
    }

    // Square the differences from the previous step
    function getSquareDifferences(uint256[] memory differences) public pure returns (uint256[] memory) {
        uint256 length = differences.length;
        uint256[] memory squareDifferences = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            squareDifferences[i] = differences[i] * differences[i];
        }

        return squareDifferences;
    }

    // Determine the sum of the squared differences
    function getSumOfSquareDifferences(uint256[] memory squareDifferences) public pure returns (uint256) {
        uint256 length = squareDifferences.length;
        uint256 sum = 0;

        for (uint256 i = 0; i < length; i++) {
            sum += squareDifferences[i];
        }

        return sum;
    }

    // Divide the differences by the total number of prices (find variance)
    function getVariance(uint256[] memory squareDifferences, uint256 length) public pure returns (uint256) {
        uint256 sumOfSquareDifferences = getSumOfSquareDifferences(squareDifferences);

        return sumOfSquareDifferences / length;
    }

    // Compute the square root of the variance computed in the previous step
    function getStandardDeviation(uint256 variance) public pure returns (uint256) {
        return sqrt(variance);
    }

    // Solidity doesn't have a built-in sqrt function, so here's an example implementation
    function sqrt(uint256 x) internal pure returns (uint256) {
        uint256 y = x;
        uint256 z = (y + 1) / 2;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
}
