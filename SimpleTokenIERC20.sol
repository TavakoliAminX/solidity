// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}




contract SimpleToken is IERC20 {
    string public name = "TTOKN";
    string public symbol = "TTOK";
    uint8 public decimals = 18;
    uint public _totalSuply;
    mapping (address => uint) public _balance;

    constructor(uint initialSuply) {
        _totalSuply = initialSuply * 10 ** uint(decimals);
        _balance[msg.sender] = _totalSuply;
        emit Transfer(address(0) , msg.sender , _totalSuply);
    }

    function balanceOf(address account) public view returns(uint){
        return _balance[account];
    }

    function totalSupply() external view returns(uint){
        return _totalSuply;
    }


    function transfer(address recipient, uint amount) external  returns(bool){
        require(_balance[msg.sender] >= amount);
        _balance[msg.sender] -= amount;
        _balance[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;


    }

}