// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IBB20.sol";

/// @title BB20 - Fractionalized NFT Token
/// @dev Only can be issued by the BluebirdGrinder
contract BB20 is IBB20, ERC20 {
    /**
     * @notice Address of the BluebirdGrinder contract
     */
    address public grinder;

    /**
     * @notice Modifier to check if is called by the BluebirdGrinder
     */
    modifier onlyGrinder() {
        _isFactory();
        _;
    }

    /**
     * @notice Constructor of the BB20 contract
     * @param _name Name of the token
     * @param _symbol Symbol of the token
     * @param _grinder Address of the BluebirdGrinder contract
     */
    constructor(string memory _name, string memory _symbol, address _grinder) ERC20(_name, _symbol) {
        grinder = _grinder;
    }

    /**
     * @notice Mint BB20 Tokens
     * @param _receipient Address of the receipient
     * @param _amount Amount of tokens to mint
     * @dev Only can be called by the BluebirdGrinder
     */
    function mint(address _receipient, uint256 _amount) external onlyGrinder {
        _mint(_receipient, _amount);
    }

    /**
     * @notice  Burn `amount` tokens and decreasing the total supply.
     * @param amount Amount of tokens to burn
     * @dev Only can be called by the BluebirdGrinder
     */
    function burn(uint256 amount) external override onlyGrinder returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    /**
     * @notice Used in modifier to check if is called by the BluebirdGrinder
     */
    function _isFactory() internal view {
        require(msg.sender == grinder, "BB20: Only grinder allowed");
    }
}
