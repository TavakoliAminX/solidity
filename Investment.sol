// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {

    function transfer(address recipient, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}


contract lending{
    address public owner;

    IERC20 public token;

    constructor(IERC20 _token){
        owner = msg.sender;
        token = _token;
    }

    mapping (address => uint) public deposits;
    struct Loan{
        uint amount;
        uint intrestRate;
        uint dueDate;
        bool active;
    }
    mapping (address => Loan[]) Loans;
    mapping (address => bool) public voters;

    event Deposit(address indexed user , uint amount);
    event WithDraw(address indexed user , uint amount);
    event LoanRequested(address indexed user ,uint amount, uint intrestRate , uint dueDate );
    event LoanRepaid(address indexed user , uint amount);

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    modifier onlyVoter(){
        require(voters[msg.sender]);
        _;
    }


    function deposit(uint amount) external {
        require(amount > 0);
        token.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint amount) external {
        require(deposits[msg.sender] >= amount);
        token.transfer(msg.sender, amount);
        deposits[msg.sender] -= amount;
        emit WithDraw(msg.sender, amount);
    }

    function requestLoen(uint amount , uint intrestRate , uint duration ) external onlyVoter{
        require(deposits[msg.sender] >= amount);
        Loans[msg.sender].push(Loan({amount: amount , intrestRate: intrestRate , dueDate: duration + block.timestamp , active: true}));
        emit LoanRequested(msg.sender, amount, intrestRate, block.timestamp + duration);
    }

    

    function repayLoan(uint index) external onlyVoter{
        Loan storage loan = Loans[msg.sender][index];
        require(loan.dueDate >= block.timestamp);
        require(loan.active);
        uint intrate = (loan.amount * loan.intrestRate) / 100;
        uint totalAmount = loan.amount + intrate;
        require(deposits[msg.sender] >= totalAmount);
        deposits[msg.sender] -= totalAmount;
        loan.active = false;
        emit LoanRepaid(msg.sender, totalAmount);
    }

    function addVoter(address voter) external  onlyOwner{
        voters[voter] = true;
    }

    function removeVoter(address voter) external onlyOwner{
        voters[voter] = false;
    }

    function changeOwner(address newOwner) external onlyOwner{
        owner = newOwner;
    }
}