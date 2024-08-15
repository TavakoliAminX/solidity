// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Token{
    string public name = "TTOKEN";
    string public symbole = "TK";
    uint public decimals = 18;
    uint public totalSuply;
    mapping (address => uint) public balance;
    mapping (address => mapping (address => uint)) public allowance;
    event Transfer(address to , uint value);
    event TransferFrom(address indexed  from , address indexed  to , uint value);
    event approval(address indexed owner , address spender , uint amount);

    struct transAction{
        address from;
        address to;
        uint amount;
        uint timestamp;
    }
    mapping (address => transAction[]) public transActions;
    constructor(uint _initialSuply){
        totalSuply = _initialSuply;
        balance[msg.sender] = _initialSuply;
    }

    function transfer(address _to , uint _amount) public returns(bool result) {
        require(balance[msg.sender] >= _amount);
        balance[msg.sender] -= _amount;
        balance[_to] += _amount;
        transActions[msg.sender].push(transAction({from: msg.sender , to: _to , amount: _amount , timestamp: block.timestamp}));
        transActions[_to].push(transAction({from: msg.sender , to:_to , amount: _amount , timestamp: block.timestamp}));
        emit Transfer(msg.sender, _amount);
        result = true;
        return result;

    }
    function transferFrom(address _from , address _to , uint _amount) public returns(bool result) {
        require(balance[_from] > _amount);
        require(allowance[_from][msg.sender] >= _amount); 
        balance[_from] -= _amount;
        balance[_to] += _amount;
        allowance[_from][_to] -= _amount;
        transActions[msg.sender].push(transAction({from: msg.sender , to: _to , amount: _amount , timestamp: block.timestamp}));
        transActions[_to].push(transAction({from: msg.sender , to:_to , amount: _amount , timestamp: block.timestamp}));
        emit  TransferFrom(_from, _to, _amount);
        result = true;
        return result;

    }

    function approve(address _spender , uint _amount) public returns(bool result){
      
        allowance[msg.sender][_spender] = _amount;
        emit approval(msg.sender, _spender, _amount);
        result = true;
        return result;

    }

}