// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import './RightToVote.sol';
import './Delegations.sol';
import './PollStructs.sol';
import './ProposalStructs.sol';
import './Predictions.sol';
import './PredictionStructs.sol';
import './PredictionBetStructs.sol';
import './PredictionBets.sol';



contract Polls is RightToVote, Delegations, PollStructs, ProposalStructs, PredictionStructs, Predictions, PredictionBetStructs, PredictionBets {

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
                proposalCount: 0,
                phase: PollPhase.createdPhase
            });

            emit PollCreated(newPoll.pollId, newPoll.title);

            polls[pollCount] = newPoll;
        }

    function _requirePollToExist(uint _pollId) internal view {
        require(_pollId > 0 && _pollId <= pollCount, "Poll ID does not exist");
    }
    modifier requirePollToExist(uint _pollId){
        _requirePollToExist(_pollId);
        _;
    }

    event ProposalAdded(uint indexed pollId, uint proposalId, string description);

    function addProposal(uint _pollId, string calldata _description) public requirePollToExist(_pollId){
        bool rightPhase = polls[_pollId].phase == PollPhase.createdPhase;
        require(rightPhase, "You can not place proposal right now");
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

    function getProposals(uint _pollId) external view requirePollToExist(_pollId) returns(Proposal[] memory) {
        return proposals[_pollId];
    }

    function getPollResults(uint _pollId) public view requirePollToExist(_pollId) returns (string[] memory, uint[] memory) {
        // requirePollToExist(_pollId);

        Proposal[] memory pollProposals = proposals[_pollId];

        string[] memory proposalDescriptions = new string[](pollProposals.length);
        uint[] memory voteCounts = new uint[](pollProposals.length);

        for (uint i; i < pollProposals.length; i++) {
            proposalDescriptions[i] = pollProposals[i].description;
            voteCounts[i] = pollProposals[i].voteCount;
        }

        return (proposalDescriptions, voteCounts);

    }

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

    event VoteSubmitted(uint indexed pollId, address indexed voter, uint votesForProposal);

    function vote(uint _pollId, uint _proposalId) public requirePollToExist(_pollId) {
        uint _pollGroup = polls[_pollId].group;
        uint delegatedVotingPower;

        // requirePollToExist(_pollId);

        require(isUserMemberOfGroup(_pollId), "The user is not a member of poll group");

        // require(block.timestamp <= polls[_pollId].endDate, "Voting is not allowed at this time");
        
        require(!hasVoted(_pollId), "Vote has already been cast");

        require(requireProposalToExist(_pollId, _proposalId));

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
}