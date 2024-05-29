// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract Booking {
    
    enum Statuses {
        Vacant,
        Occupied
    }
    Statuses currentStatus;
    event Occupy(address _occupant, uint256 _value);
    address payable public owner;
    constructor() {
        owner = payable(msg.sender);
        currentStatus = Statuses.Vacant;
    }

    modifier OnlyWhileVacant() {
        require(currentStatus == Statuses.Vacant);
        _;
    }
    modifier Costs(uint256 _amount) {
        require(msg.value >= _amount);
        _;
    }
    receive() external payable OnlyWhileVacant Costs(1 ether) {
        currentStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender, msg.value);
    }
}