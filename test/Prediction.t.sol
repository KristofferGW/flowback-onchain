// // SPDX-License-Identifier: UNLICENSED 
// pragma solidity ^0.8.0;

// import "forge-std/Test.sol";
// import "src/Prediction.sol";

// contract TestPredictions is Test {
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
// }