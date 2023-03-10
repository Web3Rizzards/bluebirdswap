// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

// import erc721
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title Mock ERC721 contract
contract Azuki is ERC721 {
    uint256 public index = 1;

    constructor() ERC721("Azuki", "AZUKI") {}

    function mint() external {
        _safeMint(msg.sender, index);
        index++;
    }

    function totalSupply() public view returns (uint256) {
        return index;
    }
}
