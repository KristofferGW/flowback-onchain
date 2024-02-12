// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import './Polls.sol';

/**
    * @title Predictions
    * @dev A contract that manages predictions for proposals.
    * @author @EllenLng, @KristofferGW
*/
contract Predictions is Polls{
 
    bool predictionFinished = false;

    // A mapping that maps a proposal ID to an array of predictions.
    mapping(uint => Prediction[]) public predictions;

    // An event that is triggered when a prediction is created
    event PredictionCreated(uint predictionId, string prediction);
 
    // A struct that represents a prediction
    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
        uint yesBets;
        uint noBets;
        PollPhase phase;   
    }

    /**
        * @dev Checks if a proposal exists.
        * @param _pollId The poll ID to check.
        * @param _proposalId The proposal ID to check.
        * @return bool Returns true if the proposal exists, false otherwise.
    */
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

    /**
        * @dev Creates a prediction for a proposal.
        * @param _pollId The poll ID to create the prediction for.
        * @param _proposalId The proposal ID to create the prediction for.
        * @param _prediction The prediction to create.
    */
    function createPrediction(
        uint _pollId, 
        uint _proposalId,
        string memory _prediction
        ) public{
            //phases
            bool rightPhase = proposals[_pollId][_proposalId -1].phase == PollPhase.predictionPhase;
            require(rightPhase, "You can not create a prediction at this time");
            Proposal storage proposal = proposals[_pollId][_proposalId -1]; // Get the proposal from the proposals mapping
            require(requireProposalToExist(_pollId, _proposalId));

            proposal.predictionCount++; //Increment by one
            uint _predictionId = proposal.predictionCount; // Set prediction id

            proposals[_pollId][_proposalId -1] = proposal; // Update mapping
   

            predictions[_proposalId].push(Prediction({
                pollId: _pollId,
                proposalId: _proposalId,
                predictionId: _predictionId,
                prediction: _prediction,
                yesBets:0,
                noBets:0,
                phase: PollPhase.predictionBetPhase
                
            }));
            emit PredictionCreated(_predictionId, _prediction);
    }

    /**
        * @dev Gets the predictions of a proposal.
        * @param _pollId The poll ID to get the predictions from.
        * @param _proposalId The proposal ID to get the predictions from.
        * @return predictions The predictions of the proposal.
    */
    function getPredictions(uint _pollId, uint _proposalId) external view returns(Prediction[] memory) {
        
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

    /**
        @dev Finishes the prediction by setting the predictionFinished variable to true.
    */
    function predictionIsFinished() internal {
        predictionFinished = true;
    }
}