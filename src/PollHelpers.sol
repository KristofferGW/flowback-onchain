// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

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
        uint8 maxVoteScore;
        uint pollId;
        uint proposalCount;
    }

    mapping(uint => Poll) public polls;

    mapping(uint => address[]) internal votersForPoll;

    mapping(uint => address[]) internal delegateVotersForPoll;

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

    function requireMaxVoteScoreWithinRange(uint8 _maxVoteScore) internal pure {
        require(_maxVoteScore <= 100, "Max vote score must be betweeen 0 and 100");
    }

    function requireVoterScoreWithinRange(uint8 _score, uint _pollId) internal view {
        require(_score <= polls[_pollId].maxVoteScore, "Vote score must be between 0 and max score");
    }

    function hasVoted(uint _pollId) internal view returns(bool voted) {
        address[] memory addresses = votersForPoll[_pollId];

        for (uint i; i < addresses.length;) {
            if (addresses[i] == msg.sender) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }

    function hasVotedAsDelegate(uint _pollId) internal view returns(bool voted) {
        address[] memory addresses = delegateVotersForPoll[_pollId];

        for (uint i; i < addresses.length;) {
            if (addresses[i] == msg.sender) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }

}