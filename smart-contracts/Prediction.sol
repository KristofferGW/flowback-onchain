// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Prediction{

    //this contract is only in development mode, some functions is only there for tests, functions may be deleted, a simple draft

    enum prediction {Yes, No}
    bool predictionFinished = false;

    mapping(prediction => uint) internal bets;
    
    //address public oracle;
    // constructor (address _oracle){
    //     oracle = _oracle;
    // }

    function placePrediction(prediction _option)  external payable {
        require(predictionFinished==false, "Prediction is finished");
        bets[_option] += 1;
    }

    function getResult() external view returns (prediction winner){
        require(predictionFinished == true, "Prediction is not finished");
        //require(msg.sender == oracle, "Access limited");
        if (bets[prediction.Yes] > bets[prediction.No]){
            return prediction.Yes;                                       // yes is currently 0
        }else if(bets[prediction.Yes] < bets[prediction.No]){
            return prediction.No;                                        // no is currently 1
        }
        //else if(A==B)
    }
    
    function predictionIsFinished() public {
        predictionFinished = true;
    }

}