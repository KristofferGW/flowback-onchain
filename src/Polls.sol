// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {RightToVote} from './RightToVote.sol';
import {Delegations} from './Delegations.sol';
import {PollHelpers} from './PollHelpers.sol';
import {ProposalHelpers} from './ProposalHelpers.sol';
import {Predictions} from './Predictions.sol';
import {PredictionHelpers} from './PredictionHelpers.sol';
import {PredictionBetHelpers} from './PredictionBetHelpers.sol';
import {PredictionBets} from './PredictionBets.sol';

// Contract needs to be deployed with the optimizer

contract Polls is RightToVote, Delegations, PollHelpers, ProposalHelpers, PredictionHelpers, Predictions, PredictionBetHelpers, PredictionBets {

    event PollCreated(uint pollId, string title);

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
                proposalCount: 0
            });

            emit PollCreated(newPoll.pollId, newPoll.title);

            polls[pollCount] = newPoll;
        }

    event ProposalAdded(uint indexed pollId, uint proposalId, string description);

    function addProposal(uint _pollId, string calldata _description) public {
        requirePollToExist(_pollId);
        controlProposalEndDate(_pollId);
        polls[_pollId].proposalCount++;
        uint _proposalId = polls[_pollId].proposalCount;

        proposals[_pollId].push(Proposal({
            description: _description,
            voteCount: 0,
            proposalId: _proposalId,
            predictionCount: 0
        }));

        emit ProposalAdded(_pollId, _proposalId, _description);
    }

    function getProposals(uint _pollId) external view returns(Proposal[] memory) {
        requirePollToExist(_pollId);
        return proposals[_pollId];
    }

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

    event VoteSubmitted(uint indexed pollId, address indexed voter, uint votesForProposal);

    function vote(uint _pollId, uint _proposalId) public {
        uint _pollGroup = polls[_pollId].group;
        uint delegatedVotingPower;
        address[] memory delegatingAddresses;

        requirePollToExist(_pollId);

        require(isUserMemberOfGroup(_pollId), "The user is not a member of poll group");

        isVotingOpen(_pollId);
        
        require(!hasVoted(_pollId), "Vote has already been cast");

        require(requireProposalToExist(_pollId, _proposalId));

        require(!hasDelegatedInGroup(_pollGroup), "You have delegated your vote in the polls group.");

        Proposal[] storage pollProposals = proposals[_pollId];

        uint pollGroupLength = groupDelegates[_pollGroup].length;

        for (uint i; i < pollGroupLength;) {
            if (groupDelegates[_pollGroup][i].delegate == msg.sender) {
                delegatedVotingPower = groupDelegates[_pollGroup][i].delegatedVotes;
                delegatingAddresses = groupDelegates[_pollGroup][i]. delegationsFrom;
            }
            unchecked {
                ++i;
            }
        }

        for (uint i; i < delegatingAddresses.length; i++) {
            uint pollDelegateEndDate = polls[_pollId].delegateEndDate;

            for (uint j = 0; j < groupDelegationsByUser[delegatingAddresses[i]].length; j++) {
                if (groupDelegationsByUser[delegatingAddresses[i]][j].groupId == _pollGroup) {
                    if (groupDelegationsByUser[delegatingAddresses[i]][j].timeOfDelegation > pollDelegateEndDate) {
                        delegatedVotingPower = delegatedVotingPower > 0 ? delegatedVotingPower - 1: 0;
                    }
                    break;
                }
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
        return;
    }

    mapping(uint => address[]) internal votersForPoll;

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

    function getPoll(uint _pollId) public view returns (Poll memory) {
        requirePollToExist(_pollId);
        return polls[_pollId];
    }
}