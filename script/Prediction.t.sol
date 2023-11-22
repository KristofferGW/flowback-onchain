// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Prediction.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";

contract PredictionTest is Test, Predictions{

    Predictions public prediction;
    //event PredictionCreated(string description, uint likelihood);
    // vm.startPrank(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);

    function setUp() public {
        prediction = new Predictions();
    }

    function run() public {
        vm.broadcast(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);
    }

    function testEmitPredictionCreated() public {
        
        vm.expectEmit(true, true, true, true);

        emit PredictionCreated("pred", 5);
        // uint _proposalId = 1;
        // string memory _description = "pred";
        // uint _likelihood= 4;
        // uint _pollId = 1;
     
        prediction.createPrediction(1, "pred", 5, 1);
       
        // console.log(success);

    }
    
}