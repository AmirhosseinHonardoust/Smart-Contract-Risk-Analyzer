// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AccessBug {
    address public owner;

    function setOwner(address newOwner) public {
        owner = newOwner;  // missing access control check!
    }
}
