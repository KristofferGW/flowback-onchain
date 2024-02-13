// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Predictions.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";

contract PredictionTest is Test, Predictions{


    Predictions public prediction;
    // vm.startPrank(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);

    function setUp() public {
        prediction = new Predictions();
    }

    function run() public {
        vm.broadcast(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);
    }
//     Predictions predictions;
//     uint pollId = 1;
//     uint proposalId = 1;
//     string prediction = "Test prediction";

//     function setUp() public {
//         predictions = new Predictions();
//     }

//     function test_createPrediction() public {
//         predictions.createPrediction(pollId, proposalId, prediction);
//         // Predictions.Prediction[] memory preds = predictions.getPredictions(pollId, proposalId);
//         // assertTrue(preds.length > 0, "Prediction should be created");
//         // assertEq(preds[0].prediction, prediction, "Prediction text should match");
//         // assertEq(preds[0].pollId, pollId, "Poll id should match");
//         // assertEq(preds[0].proposalId, proposalId, "Proposal id should match");
//     }

//     // function test_requireProposalToExist() public {
//     //     uint pollId = 1;
//     //     uint proposalId = 1;
//     //     bool exists = predictions.requireProposalToExist(pollId, proposalId);
//     //     assertTrue(exists, "Proposal should exist");
//     // }

//     // function test_getPredictions() public {
//     //     Predictions.Prediction[] memory preds = predictions.getPredictions(pollId, proposalId);
//     //     assertTrue(preds.length > 0, "Should return predictions");
//     // }





    function testEmitPredictionCreated() public {
        
         vm.expectEmit();

        emit PredictionCreated(1, "pred");

        prediction.createPrediction(1, 1, "pred");
        
    //         Traces:
    //       [13117] PredictionTest::testEmitPredictionCreated()
    // ├─ [0] VM::expectEmit()
    // │   └─ ← ()
    // ├─ emit PredictionCreated(predictionId: 1, prediction: "pred")
    // ├─ [3009] Predictions::createPrediction(1, 1, "pred")
    // │   └─ ← panic: array out-of-bounds access (0x32)
    // └─ ← log != expected log   

    }
//     function testRequireProposalToExist(uint _pollId, uint _proposalId) public {
//         assertFalse(prediction.requireProposalToExist(_pollId, _proposalId));
        // internal function
    //}
}

