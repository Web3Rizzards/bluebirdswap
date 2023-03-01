// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IBB20.sol";

/// @title BB20 - Fractionalized NFT Token
/// @dev Only can be issued by the BluebirdGrinder
contract BB20 is IBB20, ERC20 {
    address public grinder;

    modifier onlyGrinder() {
        _isFactory();
        _;
    }

    constructor(string memory _name, string memory _symbol, address _grinder) ERC20(_name, _symbol) {
        grinder = _grinder;
    }

    /**
     * @dev Mint BB20 Tokens
     */
    function mint(address _receipient, uint256 _amount) external onlyGrinder {
        _mint(_receipient, _amount);
    }

    /**
     * @notice  Burn `amount` tokens and decreasing the total supply.
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) external override onlyGrinder returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function _isFactory() internal view {
        require(msg.sender == grinder, "BB20: Only grinder allowed");
    }
}
