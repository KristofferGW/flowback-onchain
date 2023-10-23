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
        mapping(uint => Proposal) proposals;
        uint proposalCount;
    }

    struct Proposal {
        string description;
        uint voteCount;
        uint proposalId;
        mapping(address => bool) hasVoted;
    }

    mapping(uint => Poll) public polls;
    uint public pollCount;

    event PollCreated(uint pollId, string title);

    event ProposalAdded(uint pollId, uint proposalId, string description);

    function createPoll(
        string memory _title,
        string memory _tag,
        uint memory _pollStartDate,
        uint memory _proposalEndDate,
        uint memory _votingStartDate, 
        uint memory _delegateEndDate,
        uint memory _endDate
        ) public {
            pollCount++;

            Poll memory newPoll = Poll({
                title: _title,
                tag: _tag,
                pollStartDate: _pollStartDate,
                proposalEndDate: _proposalEndDate,
                votingStartDate: _votingStartDate,
                delegateEndDate: _delegateEndDate,
                endDate: _endDate
            });

            polls[pollCount] = newPoll;

            emit PollCreated(pollCount, _title, _subject);
        }
    
}