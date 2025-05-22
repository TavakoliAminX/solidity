// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// This contract allows ETH to be received and the entire balance to be withdrawn (and contract destroyed) by the owner.
contract self {
    // State variable to store the owner address
    address public owner;

    // Event emitted when ether is deposited into the contract
    event deposit(address sender, uint amount);

    // Event emitted when ether is withdrawn and contract is self-destructed
    event Withdraw(address sender, uint amount);

    // Constructor is called when the contract is deployed
    // It sets the owner of the contract
    constructor(address _owner) {
        owner = _owner;
    }

    // Special function to receive Ether.
    // It's triggered when Ether is sent to the contract without any data.
    receive() external payable {
        emit deposit(msg.sender, msg.value); // Log the deposit event
    }

    // Function to withdraw all ether and destroy the contract
    // Only callable by the owner (verified by passing their address as a parameter)
    function withdraw(address _adr) external payable {
        require(owner == _adr, "Only the owner can withdraw and destroy the contract");
        selfdestruct(payable(msg.sender)); // Sends all ETH to the caller and destroys the contract
        emit Withdraw(_adr, msg.value); // Log the withdrawal (note: msg.value will usually be 0 here)
    }
}
