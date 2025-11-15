// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OracleVuln {
    uint256 public price;

    function setPrice(uint256 newPrice) public {
        price = newPrice; // anyone can change price
    }

    function buy() public payable {
        require(msg.value >= price, "insufficient");
        // do purchase logic
    }
}
