// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SafeContract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {}

    function withdraw(uint amount) public {
        require(msg.sender == owner, "only owner");
        payable(owner).transfer(amount);
    }
}
