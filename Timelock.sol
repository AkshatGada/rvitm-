// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTimeLock {
    address public owner;
    uint256 public releaseTime;
    uint256 public depositAmount;

    event EtherDeposited(address indexed depositor, uint256 amount, uint256 releaseTime);
    event EtherWithdrawn(address indexed withdrawer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyAfter(uint256 _time) {
        require(block.timestamp >= _time, "Time lock not expired");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 _lockDurationInSeconds) external payable onlyOwner {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        require(_lockDurationInSeconds > 0, "Lock duration must be greater than zero");

        depositAmount = msg.value;
        releaseTime = block.timestamp + _lockDurationInSeconds;

        emit EtherDeposited(msg.sender, msg.value, releaseTime);
    }

    function withdraw() external onlyOwner onlyAfter(releaseTime) {
        require(depositAmount > 0, "No Ether to withdraw");

        uint256 amountToWithdraw = depositAmount;
        depositAmount = 0;

        payable(owner).transfer(amountToWithdraw);

        emit EtherWithdrawn(msg.sender, amountToWithdraw);
    }

     receive() external payable {
        // Allow the contract to receive Ether
    }
}
