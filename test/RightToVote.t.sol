// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/RightToVote.sol";
import "forge-std/Vm.sol";

contract RightToVoteTest is Test, RightToVote {

    RightToVote public rightToVote;
    
    function setUp() public {
        rightToVote = new RightToVote();
    }

    function run() public {
       vm.broadcast(); 
    }

    function testEmitPredictionCreated() public {
        vm.expectEmit();
        emit PermissionGivenToVote(1);
        rightToVote.becomeMemberOfGroup(1);  
    }

    function testbecomeMemberOfGroup(uint group) public {
        rightToVote.becomeMemberOfGroup(group);
        assertTrue(rightToVote.isUserMemberOfGroup(group));
    }

    function testRemoveGroupMembership(uint group) public {
        assertEq(rightToVote.isUserMemberOfGroup(group), false);
    }
    function testGetGroupsUserIsMemberIn() public {
        rightToVote.becomeMemberOfGroup(4);
        assertEq(rightToVote.getGroupsUserIsMemberIn()[0], 4);
    }
    
}