// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {RightToVote} from './RightToVote.sol';
import {Delegations} from './Delegations.sol';
import {PollHelpers} from './PollHelpers.sol';
import {ProposalHelpers} from './ProposalHelpers.sol';
import {Predictions} from './Predictions.sol';
import {PredictionHelpers} from './PredictionHelpers.sol';
import {PredictionBetHelpers} from './PredictionBetHelpers.sol';
import {PredictionBets} from './PredictionBets.sol';

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
        uint _endDate,
        uint8 _maxVoteScore
        ) public {
            requireMaxVoteScoreWithinRange(_maxVoteScore);
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
                maxVoteScore: _maxVoteScore,
                pollId: pollCount, 
                proposalCount: 0
            });

            emit PollCreated(newPoll.pollId, newPoll.title);

            polls[pollCount] = newPoll;
        }

    event VoteSubmitted(uint indexed pollId, address indexed voter, uint votesForProposal);

    function vote(uint _pollId, uint _proposalId, uint8 _score) public {
        uint _pollGroup = polls[_pollId].group;

        requirePollToExist(_pollId);

        require(isUserMemberOfGroup(_pollId), "The user is not a member of poll group");

        isVotingOpen(_pollId);
        
        require(!hasVoted(_pollId), "Vote has already been cast");

        require(requireProposalToExist(_pollId, _proposalId));

        require(!hasDelegatedInGroup(_pollGroup), "You have delegated your vote in the polls group.");

        requireVoterScoreWithinRange(_score, _pollId);

        Proposal[] storage pollProposals = proposals[_pollId];

        uint proposalsLength = pollProposals.length;

        uint _votesForProposal;

        for (uint i; i < proposalsLength;) {
            if (pollProposals[i].proposalId == _proposalId) {
                pollProposals[i].voteCount += 1;
                pollProposals[i].score += _score;
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

    function voteAsDelegate(uint _pollId, uint _proposalId, uint8 _score) public {
        uint _pollGroup = polls[_pollId].group;
        uint delegatedVotingPower;
        address[] memory delegatingAddresses;

        requirePollToExist(_pollId);

        require(isUserMemberOfGroup(_pollId), "The user is not a member of poll group");

        isVotingOpen(_pollId);
        
        require(!hasVotedAsDelegate(_pollId), "Delegate vote has already been cast");

        require(requireProposalToExist(_pollId, _proposalId));

        require(!hasDelegatedInGroup(_pollGroup), "You have delegated your vote in the polls group.");

        requireVoterScoreWithinRange(_score, _pollId);

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
                pollProposals[i].voteCount += delegatedVotingPower;
                pollProposals[i].score += _score * delegatedVotingPower;
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
}