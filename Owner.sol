// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Owner {
    address owner;
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    constructor(){
        owner = msg.sender;
    }
    
    function getBalanceOfContract() public view returns(uint) {
        return address(this).balance;
    }
    
    function getBalanceOfOwner() public view onlyOwner returns(uint){
        return owner.balance;
    }
    
    function getBalanceOfSender() public view returns(uint) {
        return msg.sender.balance;
    }
    
    function getAddressOfContract() public view returns(address) {
        return address(this);
    }
   
    function getAddressOfOwner() public view returns(address) {
        return owner;    
    }
     
    function getAddressOfSender() public view returns(address) {
        return msg.sender;
    }
}