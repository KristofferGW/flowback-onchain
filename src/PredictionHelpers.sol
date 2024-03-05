// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import {PollHelpers} from './PollHelpers.sol';
import {ProposalHelpers} from './ProposalHelpers.sol'; 

contract PredictionHelpers is PollHelpers, ProposalHelpers {
   
    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
    }
    
   

    mapping(uint => Prediction[]) public predictions;
}