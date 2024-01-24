// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import './Prediction.sol';

contract PredictionBets is Predictions {

    struct PredictionBet{
        uint pollId;
        uint proposalId;
        uint predictionId;
        bool bet;
        uint likelihood;
        PollPhase phase;   //Phases
    }

    mapping(uint => PredictionBet[]) public predictionBets;
    // event PredictionBetCreated(uint indexed predictionId, bool bet, uint likelihood);

    function placePredictionBet(
        uint _pollId,
        uint _proposalId,
        uint _predictionId,
        uint _likelihood,
        bool _bet

    )  external {
        // require(!predictionFinished, "Prediction is finished");
        require(requirePredictionToExist(_pollId, _proposalId, _predictionId), "Prediction does not exist");
        // require(_likelihood >=  0 && _likelihood <= 1, "Value needs to be between 0-1");
       
        //phases
            if (predictions[_proposalId][_predictionId].phase == PollPhase.predictionBetPhase) {
                    predictionBets[_predictionId].push(PredictionBet({
                        pollId: _pollId,
                        proposalId: _proposalId,
                        predictionId: _predictionId,
                        likelihood: _likelihood,
                        bet: _bet,
                        phase: PollPhase.completedPhase
                
                    }));
            }
            // bool rightPhase = predictions[_proposalId][_predictionId].phase == PollPhase.predictionBetPhase;
            // require(rightPhase, "You can not bet at this time");
            
    

        // emit PredictionBetCreated(_predictionId, _bet, _likelihood);

             
    }
    function getPredictionBets(uint _pollId, uint _proposalId, uint _predictionId) external view returns(PredictionBet[] memory) {
        uint proposalsLength = proposals[_pollId].length;
        for (uint a=0; a <= proposalsLength;){   
            if(proposals[_pollId][a].proposalId == _proposalId){
                uint predictionsLength =predictions[_proposalId].length;
                for (uint b=0; b <= predictionsLength;b++){   
                    if(predictions[_proposalId][b].predictionId == _predictionId)      //gasoptimering
                        return predictionBets[_predictionId];
                    unchecked {
                        ++b;
                    } 
                }  
            }
            unchecked {
                ++a;
            }  
        }  
        return predictionBets[_predictionId]; 
    }
    function requirePredictionToExist(uint _pollId, uint _proposalId, uint _predictionId) internal view returns (bool){

        uint proposalsLength = proposals[_pollId].length;
        for (uint a=0; a <= proposalsLength;){
            if (proposals[_pollId][a].proposalId ==_proposalId){
                uint predictionsLength = predictions[_proposalId].length;
                for (uint b=0; b <= predictionsLength;){   
                    if (predictions[_proposalId][b].predictionId ==_predictionId)   
                        return true;
                        unchecked {
                            ++b;
                        }  
                }    
                return false;   
            }
            unchecked {
            ++a;
            }
        }    
        return false;
    }

}