// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BB20 is ERC20 {
    event Minted(address to, uint256 amount);
    address public factory;

    modifier onlyFactory {
        _isFactory();
        _;
    }
    
    constructor(string memory _name, string memory _symbol, address _factory) ERC20(_name, _symbol) {
        factory = _factory;
    }

    /**
     * @notice  Burn `amount` tokens and decreasing the total supply.
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) external returns (bool) onlyFactory {
        _burn(_msgSender(), amount);
        return true;
    }

    /**
     * @dev Mint BB20 Tokens
     */
    function mint(address _receipient, uint256 _amount) external onlyFactory {
        _mint(_receipient, _amount);
    }

    function _isFactory() internal view returns (bool) {
        require (msg.sender == factory, "BB20: Only factory allowed");
    }
}
