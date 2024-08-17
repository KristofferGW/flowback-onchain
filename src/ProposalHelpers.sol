// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {PollHelpers} from './PollHelpers.sol';

contract ProposalHelpers is PollHelpers {

    struct Proposal {
        string description;
        uint voteCount;
        uint proposalId;
        uint predictionCount;
        uint score;
    }

    //Ties proposals to polls by pollId
    mapping(uint => Proposal[]) public proposals;

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
            predictionCount: 0,
            score: 0
        }));

        emit ProposalAdded(_pollId, _proposalId, _description);
    }

    function getProposals(uint _pollId) external view returns(Proposal[] memory) {
        requirePollToExist(_pollId);
        return proposals[_pollId];
    }

    function requireProposalToExist (uint _pollId, uint _proposalId) internal view returns (bool) {
        uint proposalsLength = proposals[_pollId].length;
        for (uint i = 0; i < proposalsLength; i++) {
            if (proposals[_pollId][i].proposalId == _proposalId) {
                return true;
            }
        }
        return false;
    }
}