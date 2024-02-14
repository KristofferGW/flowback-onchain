   // SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import './PollStructs.sol';
import './ProposalStructs.sol'; 
import './PredictionStructs.sol'; 

contract PredictionBetStructs is PollStructs, ProposalStructs, PredictionStructs {
   
     struct PredictionBet{
        uint pollId;
        uint proposalId;
        uint predictionId;
        bool bet;
        uint likelihood;
        PollPhase phase;
    }

    mapping(uint => PredictionBet[]) public predictionBets;
}