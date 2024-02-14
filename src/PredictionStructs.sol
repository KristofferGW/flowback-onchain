// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import './PollStructs.sol';
import './ProposalStructs.sol'; 

contract PredictionStructs is PollStructs, ProposalStructs {
   
    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
        PollPhase phase;   
    }
    
    event PredictionCreated(uint predictionId, string prediction);

    mapping(uint => Prediction[]) public predictions;
}