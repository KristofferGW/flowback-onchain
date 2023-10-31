// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Polls.sol';

contract Predictions is Polls{

    //this contract is only in development mode, some functions is only there for tests, functions may be deleted, a simple draft

    enum predictionBet {Yes, No}
    bool predictionFinished = false;

    mapping(predictionBet => uint) internal bets;
    mapping(uint => Prediction[]) public predictions;
    

    event PredictionCreated(string description, uint likelihood);

    struct Prediction{
        uint predictionId;
        string description;
        uint likelihood;
    }

    function createPrediction(
        uint _proposalId,
        string memory _description,
        uint _likelihood
        ) public {
            
            proposals[_proposalId].predictionCount++; //--------!!!!!!
            uint _predictionId = proposals[_proposalId].predictionCount;

            predictions[_proposalId].push(Prediction({
                predictionId: _predictionId,
                description: _description,
                likelihood: _likelihood
            }));
        
            emit PredictionCreated(_description, _likelihood);
    }
        
        
    function getPrediction(uint _proposalId) external view returns(Prediction[] memory) {
        return predictions[_proposalId];
    }
    
    //----------------------------------------------------------------------------------------------------

    function placePrediction(predictionBet _option, uint _likelihood)  external payable {
        require(predictionFinished==false, "Prediction is finished");
         //add likelihood
        bets[_option] += 1;
        bets[_option].likelihood = _likelihood;
    }

    // function getResult() external view returns (predictionBet winner){
    //     require(predictionFinished == true, "Prediction is not finished");
        
    //     if (bets[predictionBet.Yes] > bets[predictionBet.No]){
    //         return predictionBet.Yes;                                       // yes is currently 0
    //     }else if(bets[predictionBet.Yes] < bets[predictionBet.No]){
    //         return predictionBet.No;                                        // no is currently 1
    //     }
    //     //else if(A==B)
    // }
    
   

    function predictionIsFinished() public {
        predictionFinished = true;
    }

}