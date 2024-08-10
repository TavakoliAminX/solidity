// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Migrate {
  address public owner;
  uint public Last_migrate;

  
  constructor(){
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function Complet(uint completed) public onlyOwner {
    Last_migrate = completed;
  }
}