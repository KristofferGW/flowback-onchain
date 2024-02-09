// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Prediction.sol";
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
    function testRequireProposalToExist(uint _pollId, uint _proposalId) public {
        assertFalse(requireProposalToExist(_pollId, _proposalId));

//         Traces:
//   [3045419] PredictionTest::setUp()
//     ├─ [2987689] → new Predictions@0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
//     │   └─ ← 14911 bytes of code
//     └─ ← ()

//   [2794] PredictionTest::testRequireProposalToExist(0, 0)
//     └─ ← panic: array out-of-bounds access (0x32)
    }
}