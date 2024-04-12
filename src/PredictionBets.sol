// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {PollHelpers} from './PollHelpers.sol';
import {ProposalHelpers} from './ProposalHelpers.sol';
import {PredictionHelpers} from './PredictionHelpers.sol';
import {PredictionBetHelpers} from './PredictionBetHelpers.sol';

contract PredictionBets is PollHelpers, ProposalHelpers, PredictionHelpers, PredictionBetHelpers {

    event PredictionBetCreated(uint indexed predictionId, bool bet, uint likelihood);

    function requirePollPropPredToExist(uint _pollId, uint _proposalId, uint _predictionId) internal view returns (bool) {
        uint pollsLength = pollCount;
        for (uint i = 0; i < pollsLength; i++) {
            if (polls[i].pollId == _pollId) {
                uint proposalsLength = proposals[_pollId].length;
                for (uint j = 0; j < proposalsLength; j++) {
                    if (proposals[_pollId][j].proposalId == _proposalId) {
                        uint predictionsLength = predictions[_proposalId].length;
                        for (uint k = 0; k < predictionsLength; k++) {
                            if (predictions[_proposalId][k].predictionId == _predictionId) {
                                return true;
                            }
                        }
                        return false;
                    }
                }
                return false;
            }
        }
        return false;
    }

    modifier requireExist(uint _pollId, uint _proposalId, uint _predictionId) {
        require(requirePollPropPredToExist(_pollId, _proposalId, _predictionId), "Wrong poll, proposal or prediction");
        _;
    }

    function placePredictionBet(
        uint _pollId,
        uint _proposalId,
        uint _predictionId,
        uint _likelihood,
        bool _bet
    ) external requireExist(_pollId, _proposalId, _predictionId) {
        require(_likelihood > 0, "Likelihood must be greater than 0");
        PredictionBet[] storage bets = predictionBets[_predictionId];
        bets.push(PredictionBet({
            pollId: _pollId,
            proposalId: _proposalId,
            predictionId: _predictionId,
            likelihood: _likelihood,
            bet: _bet
        }));
        emit PredictionBetCreated(_predictionId, _bet, _likelihood);
    }

    function getPredictionBets(uint _pollId, uint _proposalId, uint _predictionId) external requireExist(_pollId, _proposalId, _predictionId) view returns (PredictionBet[] memory) {
        return predictionBets[_predictionId];
    }
}