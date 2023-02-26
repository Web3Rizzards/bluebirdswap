// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BluebirdFaucet is Ownable {
    // Whitelist Mapping
    mapping(address => bool) public whitelisted;
    address public BB;
    address public USDC;

    // onlyWhitelisted modifier
    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Faucet: Not whitelisted");
        _;
    }

    constructor(address _BB, address _USDC) {
        whitelisted[msg.sender] = true;
        BB = _BB;
        USDC = _USDC;
    }

    function drip() external onlyWhitelisted {

        BB.call(abi.encodeWithSignature("devMint(uint256)", 20000 ether));
        USDC.call(abi.encodeWithSignature("devMint(uint256)", 20000 ether));
  
    }

    function whitelistAddresses(address[] calldata _addresses) external onlyOwner {
        for (uint256 i; i < _addresses.length; i++) {
            whitelisted[_addresses[i]] = true;
        }
    }
}
