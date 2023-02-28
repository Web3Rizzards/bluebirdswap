// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20 {
    event Minted(address to, uint256 amount);

    constructor() ERC20("Mock USDC", "USDC") {}

    /**
     * @notice  Burn `amount` tokens and decreasing the total supply.
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) external returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    /**
     * @dev Mint BB
     */
    function devMint(uint256 _amount) external {
        _mint(tx.origin, _amount);
    }
}
