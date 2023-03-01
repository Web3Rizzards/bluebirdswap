// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title BB20 - Fractionalized NFT Token
/// @dev Only can be issued by the BluebirdGrinder
interface IBB20 is IERC20 {
    event Minted(address to, uint256 amount);

    /**
     * @dev Mint BB20 Tokens
     */
    function mint(address _receipient, uint256 _amount) external;

    /**
     * @notice  Burn `amount` tokens and decreasing the total supply.
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) external returns (bool);
}
