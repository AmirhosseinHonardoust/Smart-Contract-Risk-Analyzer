// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DangerousDelegate {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function run(bytes memory data, address target) public {
        require(tx.origin == owner, "bad access control"); // risky!
        (bool s, ) = target.delegatecall(data);            // VERY risky
        require(s);
    }
}
