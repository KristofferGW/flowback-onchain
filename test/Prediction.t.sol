
// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";
import "src/Polls.sol";

contract PredictionTest is Test, Polls{

    Polls public testPolls;
    uint pollStartDate = 1708672110;
    uint proposalEndDate = 1708672110 + 1 days;
    uint votingStartDate = 1708672110 + 2 days;
    uint delegateEndDate = 1708672110 + 3 days;
    uint endDate = 1708672110 + 4 days;

    function setUp() public {
        testPolls = new Polls();
    }

    function run() public {
        vm.broadcast(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);
    }

    function testCreatePrediction() public {
     
        testPolls.createPoll(
            "new poll", 
            "tag", 
            1, 
            pollStartDate, 
            proposalEndDate , 
            votingStartDate, 
            delegateEndDate, 
            endDate
            );
        vm.expectRevert(bytes("Proposal does not exist"));
        testPolls.createPrediction(1, 1, "pred");
        vm.stopPrank();
        testPolls.addProposal(1, "new proposal");
        testPolls.createPrediction(1, 1, "predone"); 
        testPolls.createPrediction(1, 1, "predtwo"); 
        Predictions.Prediction[] memory preds = testPolls.getPredictions(1, 1);
        assertEq(preds[0].prediction, "predone");
        assertEq(preds[1].prediction, "predtwo");
        assertEq(preds[0].predictionId, 1);
        assertEq(preds[1].predictionId, 2);
        assertEq(preds.length, 2);

    }

    function testGetPredictions() public {
        vm.expectRevert(bytes("Proposal does not exist"));
        testPolls.getPredictions(1, 1);
        vm.stopPrank();
        testPolls.createPoll(
            "new poll", 
            "tag", 
            1, 
            pollStartDate, 
            proposalEndDate , 
            votingStartDate, 
            delegateEndDate, 
            endDate
            );
        testPolls.addProposal(1, "new proposal");
        testPolls.createPrediction(1, 1, "predone"); 
        testPolls.createPrediction(1, 1, "predtwo");  
        Predictions.Prediction[] memory preds = testPolls.getPredictions(1, 1);
        assertEq(preds[0].predictionId, 1);
        assertEq(preds[1].predictionId, 2);
        assertEq(preds[0].prediction, "predone");
        assertEq(preds[1].prediction, "predtwo");
        assertTrue(preds.length > 0, "Should return predictions");

    }


    function testEmitPredictionCreated() public {
        testPolls.createPoll(
            "new poll", 
            "tag", 
            1, 
            pollStartDate, 
            proposalEndDate , 
            votingStartDate, 
            delegateEndDate, 
            endDate
            );
        testPolls.addProposal(1, "new proposal");
        vm.expectEmit();
        emit PredictionCreated(1,1,1, "pred");
        testPolls.createPrediction(1, 1, "pred");  
    }

//     function testRequireProposalToExist(uint _pollId, uint _proposalId) public {
//         assertFalse(prediction.requireProposalToExist(_pollId, _proposalId));
// -----   internal function  -----
//  }
 }


