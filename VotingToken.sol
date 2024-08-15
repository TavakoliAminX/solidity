// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract VotingToken {
  
    string public name = "VotingToken";
    string public symbol = "VTK";
    uint public decimals = 18;
    uint public totalSupply;


    mapping(address => uint) public balance;

    mapping(address => mapping(address => uint)) public allowance;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    struct Transaction {
        address from;
        address to;
        uint amount;
        uint timestamp;
    }

    mapping(address => Transaction[]) public transactions;

    struct Proposal {
        string description;
        uint voteCount;
        bool active;
        mapping(address => bool) voters;
    }

    Proposal[] public proposals;

    event Voted(address indexed voter, uint indexed proposalId, uint votes);

    constructor(uint _initialSupply) {
        totalSupply = _initialSupply;
        balance[msg.sender] = _initialSupply; 
    }

    function transfer(address _to, uint _amount) public returns (bool result) {
        require(balance[msg.sender] >= _amount);
        balance[msg.sender] -= _amount;
        balance[_to] += _amount;

        transactions[msg.sender].push(Transaction({from: msg.sender,to: _to,amount: _amount,timestamp: block.timestamp}));
        transactions[_to].push(Transaction({from: msg.sender, to: _to,amount: _amount,timestamp: block.timestamp}));

        emit Transfer(msg.sender, _to, _amount);
        result = true;
        return result;
    }

    function approve(address _spender, uint _amount) public returns (bool result) {
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        result = true;
        return result;
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool result) {
        require(balance[_from] >= _amount);
        require(allowance[_from][msg.sender] >= _amount);

        balance[_from] -= _amount;
        balance[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;

        transactions[_from].push(Transaction({ from: _from, to: _to, amount: _amount, timestamp: block.timestamp}));
        transactions[_to].push(Transaction({ from: _from, to: _to, amount: _amount, timestamp: block.timestamp}));

        emit Transfer(_from, _to, _amount);
        result = true;
        return result;
    }

    function createProposal(string memory _description) public {
        Proposal storage newProposal = proposals.push();
        newProposal.description = _description;
        newProposal.active = true;
    }

    function vote(uint _proposalId, uint _votes) public {
        Proposal storage proposal = proposals[_proposalId];

        require(proposal.active);
        require(balance[msg.sender] >= _votes);
        require(!proposal.voters[msg.sender]);

        proposal.voteCount += _votes;
        proposal.voters[msg.sender] = true;
        balance[msg.sender] -= _votes;

        transactions[msg.sender].push(Transaction({ from: msg.sender, to: address(this), amount: _votes, timestamp: block.timestamp}));

        emit Voted(msg.sender, _proposalId, _votes);
    }

    function closeProposal(uint _proposalId) public {
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.active);
        proposal.active = false;
    }

    function getTransactions(address _owner) public view returns (Transaction[] memory) {
        return transactions[_owner];
    }
}
