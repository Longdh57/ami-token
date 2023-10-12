// SPDX-License-Identifier: MIT
// Tells the Solidity compiler to compile only from v0.8.13 to v0.9.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AmiCatToken is ERC20 {
    address private _owner;
    uint256 private _ownerTokenInitial = 5000 * 10 ** decimals();
    uint256 private maxSupply = 10000000 * 10 ** decimals();

    constructor() ERC20("Ami Cat", "AMI") {
        _owner = msg.sender;
        super._mint(msg.sender, _ownerTokenInitial);
    }

    /**
     * @dev Get address of smart contract owner
     */
    function getOwner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Only owner can mint token and revert if totalSupply > maxSupply
     */
    function mint(uint256 amount) public {
        require(msg.sender == _owner, "Only owner can mint tokens");
        require((super.totalSupply() + amount) <= maxSupply, "Over max supply");
        super._mint(msg.sender, amount);
    }
}
