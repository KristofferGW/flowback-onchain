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

    mapping(uint => Proposal) public proposals;

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

    function addProposal(uint pollId, string memory description) public {
        polls[pollId].proposalCount++;
    }
    
}