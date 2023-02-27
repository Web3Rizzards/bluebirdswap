// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NFTToken is ERC20 {
    event Minted(address to, uint256 amount);
    address public factory;
    constructor(string memory _name, string memory _symbol, address _factory) ERC20(_name, _symbol) {
        factory = _factory;
    }
    /**
     * @notice  Burn `amount` tokens and decreasing the total supply.
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) external returns (bool) {
        require(msg.sender == factory, "Only factory can burn");
        _burn(_msgSender(), amount);
        return true;
    }

    /**
     * @dev Mint NFTTokens
     */
    function mint(address _receipient, uint256 _amount) external {
        require(msg.sender == factory, "Only factory can mint");
        _mint(_receipient, _amount);
    }
}
