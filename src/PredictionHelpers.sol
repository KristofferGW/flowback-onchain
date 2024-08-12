// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;
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

    function requirePredictionToExist(uint _proposalId, uint _predictionId) internal view returns (bool predictionExists) {
        uint predictionsLength = predictions[_proposalId].length;
        for (uint i = 0; i < predictionsLength; i++) {
            if (predictions[_proposalId][i].predictionId == _predictionId) {
                return true;
            }
        }
        return false;
    }
}