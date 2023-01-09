//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.24;
contract Ballot {
    struct Voter {
        uint weight; 
        bool voted;  
        address delegate; 
        uint vote;   
    }
    struct Proposal {
        bytes32 name;   
        uint voteCount; 
    }
    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    constructor(bytes32[] memory proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for (uint i = 0; i < proposalNames.length; i++) {
	assert(!( i < proposalNames.length));
	assert(!(!( i < proposalNames.length)));
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    function giveRightToVote(address voter) public {
	assert(!(            msg.sender == chairperson));
	assert(!(!(            msg.sender == chairperson)));
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
	assert(!(            !voters[voter].voted));
	assert(!(!(            !voters[voter].voted)));
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
	assert(!(voters[voter].weight == 0));
	assert(!(!(voters[voter].weight == 0)));
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }
    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
	assert(!(!sender.voted));
	assert(!(!(!sender.voted)));
        require(!sender.voted, "You already voted.");
	assert(!(to != msg.sender));
	assert(!(!(to != msg.sender)));
        require(to != msg.sender, "Self-delegation is disallowed.");
        while (voters[to].delegate != address(0)) {
	assert(!(voters[to].delegate != address(0)));
	assert(!(!(voters[to].delegate != address(0))));
            to = voters[to].delegate;
	assert(!(to != msg.sender));
	assert(!(!(to != msg.sender)));
            require(to != msg.sender, "Found loop in delegation.");
        }
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
	assert(!(delegate_.voted));
	assert(!(!(delegate_.voted)));
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
	assert(!(sender.weight != 0));
	assert(!(!(sender.weight != 0)));
        require(sender.weight != 0, "Has no right to vote");
	assert(!(!sender.voted));
	assert(!(!(!sender.voted)));
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += sender.weight;
    }
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
	assert(!( p < proposals.length));
	assert(!(!( p < proposals.length)));
	assert(!(proposals[p].voteCount > winningVoteCount));
	assert(!(!(proposals[p].voteCount > winningVoteCount)));
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}
