pragma solidity ^0.5.17;

contract EtherTransfer {
    address public owner;

    // Constructor to set the owner of the contract
    constructor() public {
        owner = msg.sender;
    }

    // Modifier to ensure only the owner can execute certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to allow anyone to send Ether to the contract
    function deposit() public payable {
        // No additional logic required, funds are sent to the contract
    }

    // Function to transfer Ether from the contract to a specified address
    function sendEther(address payable recipient, uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Not enough balance in the contract");
        require(amount > 0, "Amount must be greater than 0");

        recipient.transfer(amount);
    }

    // Function to get the contract's balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
