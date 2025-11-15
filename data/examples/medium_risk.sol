// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MediumRisk {
    function pay1() public payable {}
    function pay2() public payable {}
    function pay3() public payable {}
    function pay4() public payable {} // triggers payable > 3 heuristic
}
