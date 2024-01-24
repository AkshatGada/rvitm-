// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TimeLock is ReentrancyGuard {
    // Contract owner
    address payable public owner;

    // Time lock variables
    uint256 public releaseTime;
    uint256 public lockDuration;

    // Deposit variables
    uint256 public depositAmount;

    event EtherDeposited(address indexed depositor, uint256 amount, uint256 lockDuration);
    event EtherWithdrawn(address indexed withdrawer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyAfter(uint256 _time) {
        require(block.timestamp >= _time, "Time lock not expired");
        _;
    }

    constructor(uint256 _lockDurationInSeconds) {
        require(_lockDurationInSeconds > 0, "Lock duration must be greater than zero");

        owner = payable(msg.sender);
        lockDuration = _lockDurationInSeconds;
        releaseTime = block.timestamp + _lockDurationInSeconds;
    }

    receive() external payable nonReentrant {
        depositAmount += msg.value;

        emit EtherDeposited(msg.sender, msg.value, lockDuration);
    }

    function withdraw() external onlyOwner onlyAfter(releaseTime) nonReentrant {
        require(depositAmount > 0, "No ether to withdraw");

        uint256 amountToWithdraw = depositAmount;
        depositAmount = 0;

        owner.transfer(amountToWithdraw);

        emit EtherWithdrawn(msg.sender, amountToWithdraw);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}