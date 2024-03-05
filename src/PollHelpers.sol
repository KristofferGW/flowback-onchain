// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract PollHelpers {

    struct Poll {
        string title;
        string tag;
        uint group;
        uint pollStartDate;
        uint proposalEndDate;
        uint votingStartDate;
        uint delegateEndDate;
        uint endDate;
        uint pollId;
        uint proposalCount;
    }

    mapping(uint => Poll) public polls;
    uint public pollCount;

    function controlProposalEndDate(uint _pollId) internal view {
        require(polls[_pollId].proposalEndDate > block.timestamp, "The proposal phase has ended.");
    }

    function isVotingOpen(uint _pollId) internal view {
        require(polls[_pollId].votingStartDate < block.timestamp && polls[_pollId].endDate > block.timestamp, "Voting is not allowed at this time");
    }

    function requirePollToExist(uint _pollId) internal view {
        require(_pollId > 0 && _pollId <= pollCount, "Poll ID does not exist");
    }

}