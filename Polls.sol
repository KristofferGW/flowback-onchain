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
    }

    mapping(uint => Poll) public polls;
    uint public pollCount;

    //Ties proposals to polls by pollId
    mapping(uint => Proposal[]) public proposals;

    event PollCreated(uint pollId, string title);

    event ProposalAdded(uint pollId, uint proposalId, string description);

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

    function addProposal(uint _pollId, string memory _description) public {
        requirePollToExist(_pollId);
        polls[_pollId].proposalCount++;

        proposals[_pollId].push(Proposal({
            description: _description,
            voteCount: 0
        }));

        emit ProposalAdded(_pollId, polls[_pollId].proposalCount, _description);
    }

    function getProposals(uint pollId) external view returns(Proposal[] memory) {
        requirePollToExist(pollId);
        return proposals[pollId];
    }
    
}