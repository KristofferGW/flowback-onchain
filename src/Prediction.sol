// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Polls.sol';

contract Predictions is Polls{
 
    bool predictionFinished = false;

    mapping(uint => Prediction[]) public predictions;
    mapping(uint => PredictionBet[]) public predictionBets;
    
    Polls pollsInstance = new Polls();

    event PredictionCreated(uint predictionId, string prediction);
    event PredictionBetCreated(uint predictionId, bool bet, uint likelihood);

    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
        uint yesBets;
        uint noBets;
    }

    struct PredictionBet{
        uint pollId;
        uint proposalId;
        uint predictionId;
        bool bet;
        uint likelihood;
    }

    function requireProposalToExist(uint _pollId, uint _proposalId) public view returns (bool){
        for (uint i=0; i <= proposals[_pollId].length;i++){
           
          if (proposals[_pollId][i].proposalId==_proposalId) {
            return true;
          }
        }
        return false;
    }

    function createPrediction(
        uint _pollId, 
        uint _proposalId,
        string memory _prediction
        
        
        ) public{
            
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
                
            }));
            emit PredictionCreated(_predictionId, _prediction);
    }

     function requirePredictionToExist(uint _pollId, uint _proposalId, uint _predictionId) internal view returns (bool){

        for (uint a=0; a <= proposals[_pollId].length; a++){
            if (proposals[_pollId][a].proposalId ==_proposalId){
                for (uint b=0; b <= predictions[_proposalId].length;b++){   
                    if (predictions[_proposalId][b].predictionId ==_predictionId)   //gasoptimering
                    return true;
                    }  
                 }
        }
         return false;  
    }
    
    function getPredictions(uint _pollId, uint _proposalId) external view returns(Prediction[] memory) {
        
        for (uint i=0; i <= proposals[_pollId].length;i++){   
            if(proposals[_pollId][i].proposalId == _proposalId)
            return predictions[_proposalId];
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
            
        predictionBets[_predictionId].push(PredictionBet({
            pollId: _pollId,
            proposalId: _proposalId,
            predictionId: _predictionId,
            likelihood: _likelihood,
            bet: _bet
                
            }));

        emit PredictionBetCreated(_predictionId, _bet, _likelihood);

             
    }

    function getPredictionBets(uint _pollId, uint _proposalId, uint _predictionId) external view returns(PredictionBet[] memory) {
        
        for (uint a=0; a <= proposals[_pollId].length;a++){   
            if(proposals[_pollId][a].proposalId == _proposalId){
                for (uint b=0; b <= predictions[_proposalId].length;b++){   
                    if(predictions[_proposalId][b].predictionId == _predictionId)      //gasoptimering
                        return predictionBets[_predictionId];
                }  
            }
        }  
        return predictionBets[_predictionId]; 
    }

    function predictionIsFinished() internal {
        predictionFinished = true;
    }

}