// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract SWAP {
    IERC20 public token1;
    IERC20 public token2;
    address public owner1;
    address public owner2;

    constructor(
        address _token1,
        address _owner1,
        address _token2,
        address _owner2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
    }
    function swap(uint256 _amount1, uint256 _amount2) public {
        require(msg.sender == owner1 || msg.sender == owner2);
        require(token1.allowance(owner1, address(this)) >= _amount1);
        require(token2.allowance(owner2, address(this)) >= _amount2);

        _safeTransferFrom(token1, owner1, owner2, _amount1);
        _safeTransferFrom(token2, owner2, owner1, _amount2);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent);
    }
}