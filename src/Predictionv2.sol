// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Predictionsv2 {

    bool predictionFinished = false;

    event PredictionCreated(uint predictionId, string prediction);

    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
        uint yesBets;
        uint noBets;
        PollPhase phase;   
    }
}