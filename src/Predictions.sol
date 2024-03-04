// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import './PollStructs.sol';
import './ProposalStructs.sol';
import './PredictionStructs.sol';

contract Predictions is PollStructs, ProposalStructs, PredictionStructs {

    function requireProposalToExist(uint _pollId, uint _proposalId) internal view returns (bool){  
        uint predictionsLength= proposals[_pollId].length;
        for (uint i=0; i < predictionsLength;){
           
            if (proposals[_pollId][i].proposalId==_proposalId) {
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
        string memory _prediction
        
        
        ) public{
             require(requireProposalToExist(_pollId, _proposalId), "Proposal does not exist");
            //phases
            bool rightPhase = proposals[_pollId][_proposalId -1].phase == PollPhase.predictionPhase;
            require(rightPhase, "You can not create a prediction at this time");
            Proposal storage proposal = proposals[_pollId][_proposalId -1]; // Get the proposal from the proposals mapping
            require(requireProposalToExist(_pollId, _proposalId), "Proposal does not exist");

            proposal.predictionCount++; //Increment by one
            uint _predictionId = proposal.predictionCount; // Set prediction id

            proposals[_pollId][_proposalId -1] = proposal; // Update mapping
   

            predictions[_proposalId].push(Prediction({
                pollId: _pollId,
                proposalId: _proposalId,
                predictionId: _predictionId,
                prediction: _prediction,
                phase: PollPhase.predictionBetPhase
                
            }));
            emit PredictionCreated(_pollId, _proposalId, _predictionId, _prediction);
    }

    function getPredictions(uint _pollId, uint _proposalId) external view returns(Prediction[] memory) {
        require(requireProposalToExist(_pollId, _proposalId), "Proposal does not exist");
        uint proposalsLength = proposals[_pollId].length;
        for (uint i=0; i <= proposalsLength;){   
            if(proposals[_pollId][i].proposalId == _proposalId)
            return predictions[_proposalId];
            unchecked {
                ++i;
            }  
        }  
        return predictions[_proposalId];
    }
}