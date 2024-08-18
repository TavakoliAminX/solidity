// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


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


contract tokenIERC20 is IERC20{
    address public Owner;

    string public name = "TVKTO";

    string public symbol = "TVK";

    uint8 public decimals = 18;

    uint public _totalSuply;

    bool public paused = false;

    mapping (address => bool) public blackList;
    mapping (address => uint ) public _balance;
    mapping (address => mapping (address => uint)) public _allowvances;

    constructor(uint initialSuply){
        Owner = msg.sender;
        _totalSuply = initialSuply * 10 ** uint(decimals);
        _balance[msg.sender] = _totalSuply;
        emit Transfer(address(0), msg.sender, _totalSuply);
    }

    modifier onlyOwner (){
        require(Owner == msg.sender);
        _;
    }

    modifier notPused(){
        require(!paused);
        _;
    }

    modifier notBlackList(address account){
        require(!blackList[account]);
        _;
    }



    function totalSupply() external view returns (uint256){
        return _totalSuply;
    }

    
    function balanceOf(address account) external view returns (uint256){
        return _balance[account];
    }

    
    function transfer(address to, uint256 amount) external returns (bool){
        require(_balance[msg.sender] >= amount);
        _balance[msg.sender] -= amount;
        _balance[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    
    function allowance(address owner, address spender) external view returns (uint256){
        return _allowvances[owner][spender];
    }

    
    function approve(address spender, uint256 amount) external returns (bool){
        _allowvances[msg.sender][spender] = amount;
        emit  Approval(msg.sender, spender, amount);
        return true;
    }


    function transferFrom(address from, address to, uint256 amount) external returns (bool){
        require(_balance[from] >= amount);
        require(_allowvances[from][msg.sender] >= amount);
        _balance[from] -= amount;
        _balance[to] += amount;
        _allowvances[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }


    function mint(uint amount) public onlyOwner{
        _totalSuply += amount;
        _balance[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
        
    }

    function burn(uint amount) public onlyOwner{
        _totalSuply -= amount;
        _balance[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
    function pauseds() public   onlyOwner {
         paused = true;
    }

    function onPaused() public onlyOwner{
        paused = false;
    }

    function blacklist(address account) public onlyOwner{
        blackList[account] = true;
    }

    function unblacklist(address account) public onlyOwner {
        blackList[account] = false;
    }

}