// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TAS is ERC20 {
    constructor() ERC20("Token", "TAS") {
        _mint(msg.sender, 20000 ether);
    }

    function getToken(uint256 _amount) public {
        _mint(msg.sender, _amount);
    }
}