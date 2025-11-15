// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReentrancyVuln {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0);
        
        // vulnerable pattern: effects come AFTER transfer
        (bool ok, ) = msg.sender.call{value: bal}("");
        require(ok);

        balances[msg.sender] = 0; 
    }
}
