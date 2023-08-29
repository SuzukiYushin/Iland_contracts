//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {

    string private _name = "SAMPLE";
    string private _symbol = "SPL";
    uint8 private _decimals = 18;

    address account = msg.sender;
    uint value = 100000000000000000000000000000;

    constructor() ERC20( _name, _symbol) {
        _mint(account, value);
    }
}
