// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/RightToVote.sol";

contract RightToVoteTest is Test, RightToVote {

    RightToVote public rightToVote;

    function setUp() public {
        rightToVote = new RightToVote();
    }

    function run() public {
        vm.broadcast();
    }

    function testGiveRightToVote(uint num) public {
        
        rightToVote.giveRightToVote(num);
        assertEq(rightToVote.checkRightsInGroup(num), true);

    }
    
}