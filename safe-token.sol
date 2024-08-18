// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract TokenIERC20 is IERC20, ReentrancyGuard {
    using SafeMath for uint256;

    address public Owner;
    string public name = "TVKTO";
    string public symbol = "TVK";
    uint8 public decimals = 18;
    uint public _totalSupply;
    bool public paused = false;

    mapping(address => bool) public blackList;
    mapping(address => uint256) public _balance;
    mapping(address => mapping(address => uint256)) public allowances;

    constructor(uint256 initialSupply) {
        Owner = msg.sender;
        _totalSupply = initialSupply.mul(10 ** uint256(decimals));
        _balance[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    modifier onlyOwner() {
        require(Owner == msg.sender, "Not the contract owner");
        _;
    }

    modifier notPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    modifier notBlackListed(address account) {
        require(!blackList[account], "Address is blacklisted");
        _;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balance[account];
    }

    function transfer(address to, uint256 amount) external override notPaused notBlackListed(msg.sender) returns (bool) {
        require(_balance[msg.sender] >= amount, "Insufficient balance");
        _balance[msg.sender] = _balance[msg.sender].sub(amount);
        _balance[to] = _balance[to].add(amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override notPaused notBlackListed(msg.sender) returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external override notPaused notBlackListed(from) notBlackListed(to) nonReentrant returns (bool) {
        require(_balance[from] >= amount, "Insufficient balance");
        require(allowances[from][msg.sender] >= amount, "Allowance exceeded");
        _balance[from] = _balance[from].sub(amount);
        _balance[to] = _balance[to].add(amount);
        allowances[from][msg.sender] = allowances[from][msg.sender].sub(amount);
        emit Transfer(from, to, amount);
        return true;
    }

    function mint(uint256 amount) public onlyOwner notPaused {
        _totalSupply = _totalSupply.add(amount);
        _balance[msg.sender] = _balance[msg.sender].add(amount);
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 amount) public onlyOwner notPaused {
        require(_balance[msg.sender] >= amount, "Insufficient balance to burn");
        _totalSupply = _totalSupply.sub(amount);
        _balance[msg.sender] = _balance[msg.sender].sub(amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    function blacklist(address account) public onlyOwner {
        blackList[account] = true;
    }

    function unblacklist(address account) public onlyOwner {
        blackList[account] = false;
    }

    function increaseAllowance(address spender, uint256 addedValue) public notPaused notBlackListed(msg.sender) returns (bool) {
        allowances[msg.sender][spender] = allowances[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public notPaused notBlackListed(msg.sender) returns (bool) {
        allowances[msg.sender][spender] = allowances[msg.sender][spender].sub(subtractedValue);
        emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
        return true;
    }
}
