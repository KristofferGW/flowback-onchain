// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import './RightToVote.sol';
import './Delegations.sol';
import './Prediction.sol';

contract Polls is RightToVote, Delegations, Predictions {
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

    struct Proposal {
        string description;
        uint voteCount;
        uint proposalId;
        uint predictionCount;
    }

    mapping(uint => Poll) public polls;
    uint public pollCount;

    //Ties proposals to polls by pollId
    mapping(uint => Proposal[]) public proposals;

    // event PollCreated(uint pollId, string title);

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

            // emit PollCreated(pollCount, _title);
        }

    function requirePollToExist(uint _pollId) internal view {
        require(_pollId > 0 && _pollId <= pollCount, "Poll ID does not exist");
    }

    event ProposalAdded(uint indexed pollId, uint proposalId, string description);

    function addProposal(uint _pollId, string calldata _description) public {
        requirePollToExist(_pollId);
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

    event VoteSubmitted(uint indexed pollId, address indexed voter, uint votesForProposal);

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

    function createPrediction(
        uint _pollId, 
        uint _proposalId,
        string calldata _prediction
        ) public {

            Proposal storage proposal = proposals[_pollId][_proposalId -1];
            require(requireProposalToExist(_pollId, _proposalId));
            
            proposal.predictionCount++; //Increment by one
            uint _predictionId = proposal.predictionCount; // Set prediction id

            proposals[_pollId][_proposalId -1] = proposal; // Update mapping

            predictions[_proposalId].push(Prediction({
                pollId: _pollId,
                proposalId: _proposalId,
                predictionId: _predictionId,
                prediction: _prediction,
                yesBets:0,
                noBets:0
                
            }));
            emit PredictionCreated(_predictionId, _prediction);
    }

    function requireProposalToExist(uint _pollId, uint _proposalId) internal view returns (bool){

        uint predictionsLength= proposals[_pollId].length;
        for (uint i=0; i <= predictionsLength;){
           
            if (proposals[_pollId][i].proposalId==_proposalId) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
        return false;
    }
    
}