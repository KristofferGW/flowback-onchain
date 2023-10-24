// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Polls {
    struct Poll {
        string title;
        string tag;
        uint pollStartDate;
        uint proposalEndDate;
        uint votingStartDate;
        uint delegateEndDate;
        uint endDate;
        uint proposalCount;
    }

    struct Proposal {
        string description;
        uint voteCount;
        uint proposalId;
    }

    mapping(uint => Poll) public polls;
    uint public pollCount;

    //Ties proposals to polls by pollId
    mapping(uint => Proposal[]) public proposals;

    event PollCreated(uint pollId, string title);

    function createPoll(
        string memory _title,
        string memory _tag,
        uint _pollStartDate,
        uint _proposalEndDate,
        uint _votingStartDate, 
        uint _delegateEndDate,
        uint _endDate
        ) public {
            pollCount++;

            Poll memory newPoll = Poll({
                title: _title,
                tag: _tag,
                pollStartDate: _pollStartDate,
                proposalEndDate: _proposalEndDate,
                votingStartDate: _votingStartDate,
                delegateEndDate: _delegateEndDate,
                endDate: _endDate,
                proposalCount: 0
            });

            polls[pollCount] = newPoll;

            emit PollCreated(pollCount, _title);
        }

    function requirePollToExist(uint _pollId) internal view {
        require(_pollId > 0 && _pollId <= pollCount, "Poll ID does not exist");
    }

    event ProposalAdded(uint pollId, uint proposalId, string description);

    function addProposal(uint _pollId, string memory _description) public {
        requirePollToExist(_pollId);
        polls[_pollId].proposalCount++;
        uint _proposalId = polls[_pollId].proposalCount;

        proposals[_pollId].push(Proposal({
            description: _description,
            voteCount: 0,
            proposalId: _proposalId
        }));

        emit ProposalAdded(_pollId, _proposalId, _description);
    }

    function getProposals(uint _pollId) external view returns(Proposal[] memory) {
        requirePollToExist(_pollId);
        return proposals[_pollId];
    }

    event VoteSubmitted(uint indexed pollId, address indexed voter, bytes32 hashedVote);

    function vote(uint _pollId, uint _proposalId, bytes32 _hashedVote) public {
        requirePollToExist(_pollId);

        require(block.timestamp >= polls[_pollId].votingStartDate && block.timestamp <= polls[_pollId].endDate, "Voting is not allowed at this time");
        
        require(!hasVoted(), "Vote has already been cast");

        require(_proposalId > 0 && _proposalId <= polls[_pollId].proposalCount, "Proposal does not exist");

        Proposal[] storage pollProposals = proposals[_pollId];

        for (uint i = 1; i < pollProposals.length; i++) {
            if (pollProposals[i].proposalId == _proposalId) {
                pollProposals[i].voteCount++;
                emit VoteSubmitted(_pollId, msg.sender, _hashedVote);
            }
        }
        revert("There is no such proposal for the specified pollId");
    }

    function hasVoted() internal view returns(bool) {
        //Verify that the voter hasn't allready voted in the specified poll//
    }
    
}