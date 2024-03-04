   // SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import {PollHelpers} from './PollHelpers.sol';
import {ProposalHelpers} from './ProposalHelpers.sol'; 
import {PredictionHelpers} from './PredictionHelpers.sol'; 

contract PredictionBetHelpers is PollHelpers, ProposalHelpers, PredictionHelpers {
   
     struct PredictionBet{
        uint pollId;
        uint proposalId;
        uint predictionId;
        bool bet;
        uint likelihood;
    }

    mapping(uint => PredictionBet[]) public predictionBets;
}