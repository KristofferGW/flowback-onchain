// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Polls.sol';

contract Predictions is Polls{
 
    bool predictionFinished;

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
    function requireProposalToExist(uint _pollId, uint _proposalId) public view returns (bool){
        uint proposalsLength = proposals[_pollId].length;
        for (uint i; i <= proposalsLength;){
           
          if (proposals[_pollId][i].proposalId==_proposalId) {
            return true;
          }
        }
        return false;

        unchecked {
            ++i;
        }
    }

    function createPrediction(
        uint _proposalId,
        string memory _description,
        uint _likelihood,
        uint _pollId // Added pollId as function parameter
        ) public{
            
            Proposal storage proposal = proposals[_pollId][_proposalId -1]; // Get the proposal from the proposals mapping
            require(requireProposalToExist(_pollId, _proposalId));

            proposal.predictionCount++; //Increment by one
            uint _predictionId = proposal.predictionCount; // Set prediction id

            proposals[_pollId][_proposalId -1] = proposal; // Update mapping
   

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
        uint predictionsLength = predictions[_proposalId].length;
        for (uint i; i <= predictionsLength;){   
          if (predictions[_proposalId][i].predictionId ==_predictionId)
          return true;
        }
        return false;
        unchecked {
            ++i;
        }
    }
    
    function getPredictions(uint _proposalId) external view returns(Prediction[] memory) {
        return predictions[_proposalId];
    }

    function placePredictionBet(
        uint _proposalId,
        uint _yesBets,
        uint _noBets,  
        uint _predictionId
    )  external {
            
        require(!predictionFinished, "Prediction is finished");
        require(requirePredictionToExist(_proposalId, _predictionId), "Prediction does not exist"); 

        if (_yesBets > 1 || _noBets > 1)
            revert("Input must be 1");
        else if(_yesBets==0 && _noBets==0)
            revert("Please place bet");
        else if(_yesBets==1 && _noBets==1)
            revert("Please bet yes or no");
        else if(_yesBets==1 && _noBets==0)
            predictions[_proposalId][_predictionId-1].yesBets += _yesBets; 
        else if(_yesBets==0 && _noBets==1)
            predictions[_proposalId][_predictionId-1].noBets += _noBets;  
    }

    // function getResult(uint _proposalId, uint _predictionId) external view returns (string memory winner){
    //     require(predictionFinished == true, "Prediction is not finished");
    //     if (predictions[_proposalId][_predictionId-1].yesBets > predictions[_proposalId][_predictionId-1].noBets){
    //         return "Yes";                               
    //     }else if(predictions[_proposalId][_predictionId-1].yesBets < predictions[_proposalId][_predictionId-1].noBets){
    //         return "No";                                     
    //     }
    //     else if(predictions[_proposalId][_predictionId-1].yesBets < predictions[_proposalId][_predictionId-1].noBets){
    //         return "Tie";
    //     }
    // }

    function predictionIsFinished() internal {
        predictionFinished = true;
    }

}
