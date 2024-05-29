// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
contract ballot2 {

    struct Voter {
        uint256 weight; 
        bool voted; 
        address delegate; 
        uint256 vote; 
    }

    struct Proposal {
        bytes32 name;
        uint256 voteCount;
    }
    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint256 i = 0; i < proposalNames.length; i++) {

            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }
    function giveRightToVote(address voter) external {
        require(msg.sender == chairperson);
        require(!voters[voter].voted);
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function delegate(address to) external {

        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0);
        require(!sender.voted);

        require(to != msg.sender);

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender);
        }

        Voter storage delegate_ = voters[to];
        require(delegate_.weight >= 1);
        sender.voted = true;
        sender.delegate = to;
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }
    function vote(uint256 proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0);
        require(!sender.voted);
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }
    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}