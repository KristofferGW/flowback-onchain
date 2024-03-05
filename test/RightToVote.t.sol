// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Polls.sol";
import "forge-std/Vm.sol";

contract RightToVoteTest is Test, Polls {

    Polls public testPolls;
    address user1 = address(0x1);
    address user2 = address(0x2);
    
    function setUp() public {
        testPolls = new Polls();
    }

    function run() public {
       vm.broadcast(); 
    }

    function testEmitPredictionCreated() public {
        vm.expectEmit();
        emit PermissionGivenToVote(1);
        testPolls.becomeMemberOfGroup(1);  
    }

    function testbecomeMemberOfGroup(uint group) public {
        vm.startPrank(user1);
        assertFalse(testPolls.isUserMemberOfGroup(group));
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(group);
        assertTrue(testPolls.isUserMemberOfGroup(group));
    }

    function testRemoveGroupMembership(uint group) public {
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(group);
        assertTrue(testPolls.isUserMemberOfGroup(group));
        vm.startPrank(user1);
        testPolls.removeGroupMembership(group);
        assertEq(testPolls.isUserMemberOfGroup(group), false);
        
    }
    function testGetGroupsUserIsMemberIn() public {
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(1);
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(4);
        assertEq(testPolls.getGroupsUserIsMemberIn()[0], 1);
        assertEq(testPolls.getGroupsUserIsMemberIn()[1], 4);
    }   
}