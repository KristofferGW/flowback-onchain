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
        uint pollId;
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

    event PollCreated(uint pollId, string name);

    event ProposalAdded(uint pollId, uint proposalId, string description);
    
}