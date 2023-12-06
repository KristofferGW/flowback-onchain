// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import './Polls.sol';

contract Predictions is Polls{
 
    bool predictionFinished = false;

    mapping(uint => Prediction[]) public predictions;
    mapping(uint => PredictionBet[]) public predictionBets;
    
    Polls pollsInstance = new Polls();

    event PredictionCreated(uint predictionId, string prediction);
    event PredictionBetCreated(uint indexed predictionId, bool bet, uint likelihood);

    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
        uint yesBets;
        uint noBets;
        //PollPhase phase;    //Phases
    }

    struct PredictionBet{
        uint pollId;
        uint proposalId;
        uint predictionId;
        bool bet;
        uint likelihood;
        //PollPhase phase;   //Phases
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

    function createPrediction(
        uint _pollId, 
        uint _proposalId,
        string calldata _prediction
        
        
        ) public{
            //phases
            // bool rightPhase = proposals[_pollId][_proposalId -1].phase == PollPhase.predictionPhase;
            // require(rightPhase, "You can not create a prediction at this time");
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
                noBets:0
                //phase: PollPhase.predictionBetPhase
                
            }));
            emit PredictionCreated(_predictionId, _prediction);
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

    function placePredictionBet(
        uint _pollId,
        uint _proposalId,
        uint _predictionId,
        uint _likelihood,
        bool _bet

    )  external {
        require(!predictionFinished, "Prediction is finished");
        require(requirePredictionToExist(_pollId, _proposalId, _predictionId), "Prediction does not exist");
        //phases
            // bool rightPhase = predicitons[_predictionId.phase == PollPhase.predictionBetPhase;
            // require(rightPhase, "You can not bet at this time");
            
        predictionBets[_predictionId].push(PredictionBet({
            pollId: _pollId,
            proposalId: _proposalId,
            predictionId: _predictionId,
            likelihood: _likelihood,
            bet: _bet
            //phase: PollPhase.completedPhase
                
            }));

        emit PredictionBetCreated(_predictionId, _bet, _likelihood);

             
    }

    function getPredictionBets(uint _pollId, uint _proposalId, uint _predictionId) internal view returns(PredictionBet[] memory) {
        
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

    function predictionIsFinished() internal {
        predictionFinished = true;
    }

}