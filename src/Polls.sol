// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import './RightToVote.sol';
import './Delegations.sol';

/**
 * @title Polls
 * @dev A contract that manages polls and proposals.
 * @author @EllenLng, @KristofferGW
*/
contract Polls is RightToVote, Delegations {

    // A struct that represents a poll
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
        PollPhase phase;
    }

    // A struct that represents a proposal
    struct Proposal {
        string description;
        uint voteCount;
        uint proposalId;
        uint predictionCount;
        PollPhase phase;
    }

    // A mapping that maps a poll ID to a Poll struct.
    mapping(uint => Poll) public polls;
    uint public pollCount;

    //Ties proposals to polls by pollId
    mapping(uint => Proposal[]) public proposals;

    // A mapping that maps a poll ID to an array of addresses that have voted in the poll.
    mapping(uint => address[]) internal votersForPoll;

    // An enum that represents the different phases of a poll
    enum PollPhase {createdPhase, predictionPhase, predictionBetPhase, completedPhase}

    // An event that is triggered when a poll is created
    event PollCreated(uint pollId, string title);
    
    // An event that is triggered when a proposal is added
    event ProposalAdded(uint indexed pollId, uint proposalId, string description);
    
    // An event that is triggered when a vote is submitted
    event VoteSubmitted(uint indexed pollId, address indexed voter, uint votesForProposal);
    
    /**
        * @dev Creates a new poll.
        * @param _title The title of the poll.
        * @param _tag The tag of the poll.
        * @param _group The group ID of the poll.
        * @param _pollStartDate The start date of the poll.
        * @param _proposalEndDate The end date of the proposal phase.
        * @param _votingStartDate The start date of the voting phase.
        * @param _delegateEndDate The end date of the delegate phase.
        * @param _endDate The end date of the poll.
    */
    function createPoll(
        string calldata _title,
        string calldata _tag,
        uint _group,
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
                group: _group,
                pollStartDate: _pollStartDate,
                proposalEndDate: _proposalEndDate,
                votingStartDate: _votingStartDate,
                delegateEndDate: _delegateEndDate,
                endDate: _endDate,
                pollId: pollCount, 
                proposalCount: 0,
                phase: PollPhase.createdPhase
            });

            emit PollCreated(newPoll.pollId, newPoll.title);

            polls[pollCount] = newPoll;
    }

    /**
        * @dev Checks if a poll exists.
        * @param _pollId The poll ID to check.
    */
    function requirePollToExist(uint _pollId) internal view {
        require(_pollId > 0 && _pollId <= pollCount, "Poll ID does not exist");
    }

    /**
        * @dev Adds a proposal to a poll.
        * @param _pollId The poll ID to add the proposal to.
        * @param _description The description of the proposal.
    */
    function addProposal(uint _pollId, string calldata _description) public {
        bool rightPhase = polls[_pollId].phase == PollPhase.createdPhase;
        require(rightPhase, "You can not place proposal right now");
        requirePollToExist(_pollId);
        polls[_pollId].proposalCount++;
        uint _proposalId = polls[_pollId].proposalCount;

        proposals[_pollId].push(Proposal({
            description: _description,
            voteCount: 0,
            proposalId: _proposalId,
            predictionCount: 0,
            phase: PollPhase.predictionPhase
        }));

        emit ProposalAdded(_pollId, _proposalId, _description);
    }

    /**
        * @dev Gets the proposals of a poll.
        * @param _pollId The poll ID to get the proposals from.
        * @return proposals The proposals of the poll.
    */
    function getProposals(uint _pollId) external view returns(Proposal[] memory) {
        requirePollToExist(_pollId);
        return proposals[_pollId];
    }

    /**
        * @dev Gets the results of a poll.
        * @param _pollId The poll ID to get the results from.
        * @return proposalDescriptions The descriptions of the proposals.
        * @return voteCounts The vote counts of the proposals.
    */
    function getPollResults(uint _pollId) public view returns (string[] memory, uint[] memory) {
        requirePollToExist(_pollId);

        Proposal[] memory pollProposals = proposals[_pollId];

        string[] memory proposalDescriptions = new string[](pollProposals.length);
        uint[] memory voteCounts = new uint[](pollProposals.length);

        for (uint i; i < pollProposals.length; i++) {
            proposalDescriptions[i] = pollProposals[i].description;
            voteCounts[i] = pollProposals[i].voteCount;
        }

        return (proposalDescriptions, voteCounts);

    }

    /**
        * @dev Checks if a user has delegated in a group.
        * @param _pollGroup The group ID to check.
        * @return hasDelegated Returns true if the user has delegated in the group, false otherwise.
    */
    function userHasDelegatedInGroup(uint _pollGroup) private view returns(bool) {
        uint[] memory delegatedGroups = groupDelegationsByUser[msg.sender];

        for (uint i; i < delegatedGroups.length;) {
            if (delegatedGroups[i] == _pollGroup) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }

    /**
        * @dev Checks if a user is a member of a poll group.
        * @param _pollId The poll ID to check.
        * @return isInGroup Returns true if the user is a member of the poll group, false otherwise.
    */
    function userIsMemberOfPollGroup(uint _pollId) internal view returns(bool isInGroup) {
        uint[] memory userGroups = voters[msg.sender].groups;

        for (uint i; i < userGroups.length;) {
            if (userGroups[i] == polls[_pollId].group) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }

    /**
        * @dev Allows a user to vote in a poll.
        * @param _pollId The poll ID to vote in.
        * @param _proposalId The proposal ID to vote for.
    */
    function vote(uint _pollId, uint _proposalId) public {
        uint _pollGroup = polls[_pollId].group;
        uint delegatedVotingPower;

        requirePollToExist(_pollId);

        require(userIsMemberOfPollGroup(_pollId), "The user is not a member of poll group");

        // require(block.timestamp <= polls[_pollId].endDate, "Voting is not allowed at this time");
        
        require(!hasVoted(_pollId), "Vote has already been cast");

        require(_proposalId > 0 && _proposalId <= polls[_pollId].proposalCount, "Proposal does not exist");

        require(!userHasDelegatedInGroup(_pollGroup), "You have delegated your vote in the polls group.");

        Proposal[] storage pollProposals = proposals[_pollId];

        uint pollGroupLength = groupDelegates[_pollGroup].length;

        for (uint i; i < pollGroupLength;) {
            if (groupDelegates[_pollGroup][i].delegate == msg.sender) {
                delegatedVotingPower = groupDelegates[_pollGroup][i].delegatedVotes;
            }
            unchecked {
                ++i;
            }
        } 

        uint proposalsLength = pollProposals.length;

        uint _votesForProposal;

        for (uint i; i < proposalsLength;) {
            if (pollProposals[i].proposalId == _proposalId) {
                pollProposals[i].voteCount += delegatedVotingPower + 1;
                _votesForProposal = pollProposals[i].voteCount;
                votersForPoll[_pollId].push(msg.sender);
                emit VoteSubmitted(_pollId, msg.sender, _votesForProposal);
                return;
            }
            unchecked {
                ++i;
            }
        }
        revert("There is no such proposal for the specified pollId");
    }

    /**
        * @dev Checks if a user has voted in a poll.
        * @param _pollId The poll ID to check.
        * @return voted Returns true if the user has voted in the poll, false otherwise.
    */
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
}