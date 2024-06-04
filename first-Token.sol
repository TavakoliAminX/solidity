// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract firsToken {
    uint public initialSupply;

    mapping(address=>uint) balances;
    
    constructor(uint _initialSupply) public {
        initialSupply = _initialSupply;
        balances[msg.sender] = _initialSupply ;
    }
    
    function transfer(address _recipient, uint _amount) public {
        require(balances[msg.sender] >= _amount);
        require(_recipient != msg.sender);
        require(balances[_recipient] + _amount > balances[_recipient]);
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
    }

    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }
}