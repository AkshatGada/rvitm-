pragma solidity ^0.5.17;

contract EtherTransfer {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function deposit() public payable {
        
    }

    function sendEther (address payable recepient,uint256 amount) public {
        require(address(this).balance >= amount);
        require(amount >0);

        recepient.transfer(amount);
    }
}