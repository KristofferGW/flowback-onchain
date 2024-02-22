// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/Polls.sol";

contract PredictionBetTest is Test, Polls{
     Polls public testPolls;

    function setUp() public {
        testPolls = new Polls();
    }

    function testEmitPlacePredictionBet() public {
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
        testPolls.addProposal(1, "new proposal");
        testPolls.createPrediction(1, 1, "pred");  
        vm.expectEmit();
        emit PredictionBetCreated(1, true, 9);
        testPolls.placePredictionBet(1, 1, 1, 9, true);  
    }

    function testPlacePredictionBet() public {
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
        testPolls.addProposal(1, "new proposal");
        testPolls.createPrediction(1, 1, "pred");  
        testPolls.placePredictionBet(1, 1, 1, 9, true);
        testPolls.placePredictionBet(1, 1, 1, 9, true);  
        PredictionBets.PredictionBet[] memory predictionbets = testPolls.getPredictionBets(1,1,1);
        assertEq(predictionbets.length, 2);

        // will work once requirePollPropPredToExist-bug is fixed -------------------------
        // vm.expectRevert(bytes("Wrong poll, proposal or prediction"));
        // 
        // (bool revertsAsExpected, ) = testPolls.placePredictionBet(2, 1, 1, 9, true);
        // assertTrue(revertsAsExpected, "expectRevert: call did not revert");
    }
    function testGetPredictionBets() public {
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
        testPolls.addProposal(1, "new proposal");
        testPolls.createPrediction(1, 1, "pred");  
        testPolls.placePredictionBet(1, 1, 1, 9, true);
        PredictionBets.PredictionBet[] memory predictionbets = testPolls.getPredictionBets(1,1,1);
        assertTrue(predictionbets.length > 0, "Should return predictionbets");
    }


//private/internal functions  ------------------------------------------------------------

    // function testRequirePollPropPredToExist() public{
    //     assertFalse(testPolls.requirePollPropPredToExist(1,1,1));
    //     testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
    //     testPolls.addProposal(1, "new proposal");
    //     testPolls.createPrediction(1, 1, "pred");
    //     assertTrue(testPolls.requirePollPropPredToExist(1,1,1));

    //     // ---- Does not return false, as it should-------------------------- ISSUE ON GITHUB
    //     assertFalse(testPolls.requirePollPropPredToExist(1,1,2)); 
    //     assertFalse(testPolls.requirePollPropPredToExist(1,2,1));
    //     assertFalse(testPolls.requirePollPropPredToExist(2,1,1));

    // }
}