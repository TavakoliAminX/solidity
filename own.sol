// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Own {
    address public owner;
    address public ADRowner;
    
    event nated(address newOwner);
    event Changed(address ADRaccount, address Owner);

    constructor()  {
        owner = address(this); 
        ADRowner = msg.sender;
        emit Changed(address(0), owner);
       
    }

      modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function NewOwner(address _owner) external onlyOwner {
        ADRowner = _owner;
        emit nated(_owner);
    }

    function accept() external {
        require(msg.sender == ADRowner);
        emit Changed(owner, ADRowner);
        owner = ADRowner;
        ADRowner = address(0);
    }

  


}