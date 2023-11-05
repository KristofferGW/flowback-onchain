// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Polls.sol';

contract Predictions is Polls{

    //this contract is only in development mode, some functions is only there for tests, functions may be deleted, a simple draft

   
    bool predictionFinished = false;

    
    mapping(uint => Prediction[]) public predictions;
    
    Polls pollsInstance = new Polls();

    event PredictionCreated(string description, uint likelihood);

    struct Prediction{
        uint predictionId;
        string description;
        uint likelihood;
        uint yesBets;
        uint noBets;
    }

    function createPrediction(
        uint _proposalId,
        string memory _description,
        uint _likelihood,
        uint _pollId // Added pollId as function parameter
        ) public {
            
            Proposal storage proposal = proposals[_pollId][_proposalId]; // Get the proposal from the proposals mapping
            

            proposal.predictionCount++; //Increment by one
            uint _predictionId = proposal.predictionCount; // Set prediction id

            proposals[_pollId][_proposalId] = proposal; // Update mapping

            predictions[_proposalId].push(Prediction({
                predictionId: _predictionId,
                description: _description,
                likelihood: _likelihood,
                yesBets: 0,
                noBets: 0
            }));
            emit PredictionCreated(_description, _likelihood);
    }

     function requirePredictionToExist(uint _proposalId, uint _predictionId) internal view returns (bool){
        for (uint i; i< predictions[_proposalId].length;i++){
          if (predictions[_proposalId][i].predictionId==_predictionId)
          return true;
        }
        return false;
    }
    
        
    function getPrediction(uint _proposalId) external view returns(Prediction[] memory) {
        return predictions[_proposalId];
    }

    function placePredictionBet(
    
        uint _proposalId,
        uint _yesBets,
        uint _noBets,  
        uint _predictionId
    )  external payable {
        require(!predictionFinished, "Prediction is finished");
        require(requirePredictionToExist(_proposalId, _predictionId), "Prediction does not exist"); 
        predictions[_proposalId][_predictionId].yesBets += _yesBets;
        predictions[_proposalId][_predictionId].noBets += _noBets;
    }

    // function getResult(uint _proposalId, uint _predictionId) external view returns (string memory winner){
    //     require(predictionFinished == true, "Prediction is not finished");
        
    //     if (predictions[_proposalId][_predictionId].yesBets > predictions[_proposalId][_predictionId].noBets){
    //         return "Yes";                               
    //     }else if(predictions[_proposalId][_predictionId].yesBets < predictions[_proposalId][_predictionId].noBets){
    //         return "No";                                     
    //     }
    //     else if(predictions[_proposalId][_predictionId].yesBets < predictions[_proposalId][_predictionId].noBets){
    //         return "Tie";
    //     }
    // }
    
   

    function predictionIsFinished() public {
        predictionFinished = true;
    }

}