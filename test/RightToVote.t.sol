// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/RightToVote.sol";
import "forge-std/Vm.sol";

contract RightToVoteTest is Test, RightToVote {

    RightToVote public rightToVote;
    //vm.startPrank(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);
    
    function setUp() public {
        rightToVote = new RightToVote();
    }

    function run() public {
       vm.broadcast(); 
    }

    function testGiveRightToVote(uint group) public {
        rightToVote.becameMemberOfGroup(group);
        assertTrue(rightToVote.isUserMemberOfGroup(group));
    }

    function testRemoveRightToVote(uint group) public {
        assertEq(rightToVote.isUserMemberOfGroup(group), false);
    }
    
}