// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RiskRegistry {
    enum RiskLevel { Low, Medium, High }

    struct Assessment {
        uint256 score;
        RiskLevel level;
        string details;
        address analyst;
        uint256 timestamp;
    }

    mapping(bytes32 => Assessment) public assessments;

    event Assessed(bytes32 indexed targetId, uint256 score, RiskLevel level, address indexed analyst);

    function submitAssessment(bytes32 targetId,uint256 score,RiskLevel level,string calldata details) external {
        require(score <= 100, "Score must be <= 100");

        assessments[targetId] = Assessment({score: score,level: level,details: details,analyst: msg.sender,timestamp: block.timestamp});

        emit Assessed(targetId, score, level, msg.sender);
    }

    function getAssessment(bytes32 targetId) external view returns (Assessment memory) {
        return assessments[targetId];
    }
}
