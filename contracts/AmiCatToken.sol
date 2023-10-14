// SPDX-License-Identifier: MIT
// Tells the Solidity compiler to compile only from v0.8.13 to v0.9.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AmiCatToken is ERC20 {
    address private _owner;
    uint256 private _ownerTokenInitial = 5000 * 10**decimals();
    uint256 private maxSupply = 10000000 * 10**decimals();

    event TokenMinted(address indexed _from, uint256 _value);

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
     * @dev Mint token with ETH, token price will increase when totalSupply near maxSupply
     * if totalSupply/maxSupply < 50%  1AMI = 0.001ETH
     * if totalSupply/maxSupply 50% - 70% 1AMI = 0.005ETH
     * if totalSupply/maxSupply 70% - 90% 1AMI = 0.01ETH
     * if totalSupply/maxSupply 90% - 95% 1AMI = 0.1ETH
     * if totalSupply/maxSupply 95% - 100% 1AMI = 1ETH
     */
    function _minFee(uint256 amount) view  private returns (uint256) {
        if (super.totalSupply() < (maxSupply * 50) / 100) {
            return amount * 1000;
        } else if (super.totalSupply() < (maxSupply * 70) / 100) {
            return amount * 200;
        } else if (super.totalSupply() < (maxSupply * 90) / 100) {
            return amount * 100;
        } else if (super.totalSupply() < (maxSupply * 95) / 100) {
            return amount * 10;
        } else {
            return amount;
        }
    }

    /**
     * @dev Everyone can mint token by pay ETH follow logic minFee
     * revert if totalSupply > maxSupply
     */
    function mint() public payable {
        require(msg.value > 0, "Only owner can mint tokens");

        uint256 amount = _minFee(msg.value);

        require((super.totalSupply() + amount) <= maxSupply, "Over max supply");

        super._mint(msg.sender, amount);

        emit TokenMinted(msg.sender, amount);
    }
}
