// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/RightToVote.sol";
import "src/Delegations.sol";
import "src/Polls.sol";
import "src/Prediction.sol";

contract TestFlowback is Test {
    RightToVote rightToVote;
    Delegations delegations;
    Polls polls;
    Predictions predictions;

    function setUp() public {
        rightToVote = new RightToVote();
        delegations = new Delegations();
        polls = new Polls();
        predictions = new Predictions();
    }

    /////////// Basic Tests ///////////

    // RightToVote
    function testCheckRightsInGroup() public {
        rightToVote.giveRightToVote(1);
        assertTrue(rightToVote.checkRightsInGroup(1));
    }

    function testCheckAllRights() public {
        rightToVote.giveRightToVote(1);
        rightToVote.giveRightToVote(2);
        assertEq(rightToVote.checkAllRights().length, 2);
    }

    function testRemoveRightToVote() public {
        rightToVote.giveRightToVote(1);
        rightToVote.removeRightToVote(1);
        assertEq(rightToVote.checkAllRights().length, 0);
    }


    // Delegations
    

}