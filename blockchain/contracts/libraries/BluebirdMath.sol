// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "hardhat/console.sol";

library BluebirdMath {
    /**
     * Compute standard deviation of an array of values
     * @param _values Array of values
     * @return Standard deviation of `_values`
     */
    function computeStandardDeviation(uint256[7] memory _values) internal view returns (uint256) {
        uint256 n = _values.length;
        uint256 mean = 0;

        // Compute mean
        for (uint256 i = 0; i < n; i++) {
            mean += _values[i];
        }
        mean = mean / n;
        // Compute sum of squared differences
        uint256 sumSquaredDifferences = 0;
        for (uint256 i = 0; i < n; i++) {
            uint256 difference;
            if (_values[i] > mean) {
                difference = _values[i] - mean;
            } else {
                difference = mean - _values[i];
            }

            sumSquaredDifferences += difference * difference;
        }

        // Compute variance and standard deviation
        uint256 variance = sumSquaredDifferences / n;
        uint256 standardDeviation = sqrt(variance);

        return standardDeviation;
    }

    /**
     * Square root function
     * @param x Input x
     * @return Square root of `x`
     */
    function sqrt(uint256 x) internal pure returns (uint256) {
        uint256 z = (x + 1) / 2;
        uint256 y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
        return y;
    }
}
