// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract raising {
    address owner;
    uint public goal;
    uint public endTime;
    uint public total = 0;
    
    mapping(address=>uint) donations;
    
    constructor(uint _goal, uint _timeLimit) public {
        owner = msg.sender;
        goal = _goal;
        endTime = block.timestamp + _timeLimit;
    }
    
    function add() payable public {
        require(block.timestamp < endTime);
        require(total < goal);
        require(msg.value > 0);
        donations[msg.sender] += msg.value; 
        total += msg.value;
    }
    
    function withdrawOwner() public {
        require(msg.sender == owner);
        require(total >= goal);
        payable (owner).transfer(address(this).balance);
    }
    
    function withdraw() public {
        require(block.timestamp > endTime);
        require(total < goal);
        uint amount = donations[msg.sender];
        total -= amount;
        donations[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}