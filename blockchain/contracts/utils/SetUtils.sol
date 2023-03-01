// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library SetUtils {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;

    /// @dev Converst an iterable set of addresses to a corresponding array
    function toArray(EnumerableSet.AddressSet storage _set) internal view returns (address[] memory) {
        uint256 numElements = _set.length();
        address[] memory elements = new address[](numElements);
        for (uint256 i = 0; i < numElements; ++i) {
            elements[i] = _set.at(i);
        }
        return elements;
    }

    /// @dev Converst an iterable set of uint to a corresponding array
    function toArray(EnumerableSet.UintSet storage _set) internal view returns (uint256[] memory) {
        uint256 numElements = _set.length();
        uint256[] memory elements = new uint256[](numElements);
        for (uint256 i = 0; i < numElements; ++i) {
            elements[i] = _set.at(i);
        }
        return elements;
    }
}
