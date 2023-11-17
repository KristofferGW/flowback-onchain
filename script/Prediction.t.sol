// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Prediction.sol";

contract PredictionTest is Test, Predictions{
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    function testCreatePrediction() public {
        
    }
    
}