// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Value{
    bool public _bool = true;
    bool public _bool1 = !_bool;
    bool public _bool2 = _bool && _bool1; 
    bool public _bool3 = _bool || _bool1;
    bool public _bool4 = _bool == _bool1;
    bool public _bool5 = _bool != _bool1;

    int public _int = -1;
    uint public _uint = 1;
    uint256 public _number = 20220330;

    uint256 public _number1 = _number + 1; 
    uint256 public _number2 = 2**2; 
        uint256 public _number3 = 7 % 2;
    bool public _numberbool = _number2 > _number3;

    address public _address = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    address payable public _address1 = payable(_address);
    uint256 public balance = _address1.balance;
    
    

    bytes32 public _byte32 = "MiniSolidity"; 
    bytes1 public _byte = _byte32[0]; 

    enum ActionSet { Buy, Hold, Sell }

    ActionSet action = ActionSet.Buy;

    function enumToUint() external view returns(uint){
        return uint(action);
    }
}