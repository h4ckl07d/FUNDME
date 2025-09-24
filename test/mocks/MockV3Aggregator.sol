// SPDX -License-Identifier:MIT;

pragma solidity ^0.8.23

contract MockV3Aggregator {
    uint8 public decimals;
    int256 public answer;
    uint256 public updatedAt;
    address public owner;

    constructor(uint8 _decimals, int256 _answer) {
        decimals = _decimals;
        answer = _answer;
        updatedAt = block.timestamp;
        owner = msg.sender;
    }

    function setAnswer(int256 _answer) external {
        require(msg.sender == owner, "Only owner can set answer");
        answer = _answer;
        updatedAt = block.timestamp;
    }
}

    function latestRoundData() external view returns (
        uint80,
        int256,
        uint256,
        uint256,
        bytes memory
    ) {
        return (0, answer, updatedAt, updatedAt, "");
    }

    function version() external pure returns (uint256) {
        return 1;
    }
}