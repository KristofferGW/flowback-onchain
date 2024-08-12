// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

import {PollHelpers} from './PollHelpers.sol';
import {ProposalHelpers} from './ProposalHelpers.sol';
import {PredictionHelpers} from './PredictionHelpers.sol';
import {PredictionBetHelpers} from './PredictionBetHelpers.sol';

contract PredictionBets is PollHelpers, ProposalHelpers, PredictionHelpers, PredictionBetHelpers {

    event PredictionBetCreated(uint indexed predictionId, bool bet, uint likelihood);

    modifier requireExist(uint _pollId, uint _proposalId, uint _predictionId) {
        requirePollToExist(_pollId);
        requireProposalToExist (_pollId, _proposalId);
        requirePredictionToExist(_proposalId, _predictionId);
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