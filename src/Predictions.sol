// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import './PollStructs.sol';
import './ProposalStructs.sol';

contract Predictions is PollStructs, ProposalStructs {
    bool predictionFinished = false;

    mapping(uint => Prediction[]) public predictions;

    event PredictionCreated(uint predictionId, string prediction);
 

    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
        uint yesBets;
        uint noBets;
        PollPhase phase;   
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