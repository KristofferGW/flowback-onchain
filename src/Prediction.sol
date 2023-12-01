// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Predictions {

    mapping(uint => Prediction[]) public predictions;

    event PredictionCreated(uint predictionId, string prediction);

    struct Prediction{
        uint pollId;
        uint proposalId;
        uint predictionId;
        string prediction;
        uint yesBets;
        uint noBets;
    }
}