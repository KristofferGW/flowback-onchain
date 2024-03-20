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
        emit GroupMembershipChanged(msg.sender, 1, true);
        testPolls.becomeMemberOfGroup(1);  
    }

    function testbecomeMemberOfGroup(uint group) public {
        vm.startPrank(user1);
        assertFalse(testPolls.isUserMemberOfGroup(group));
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(group);
        assertTrue(testPolls.isUserMemberOfGroup(group));
        assertEq(testPolls.getGroupsUserIsMemberIn()[0], group);
    }

    function testRemoveGroupMembership(uint group) public {
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(group);
        assertTrue(testPolls.isUserMemberOfGroup(group));
        vm.startPrank(user1);
        testPolls.removeGroupMembership(group);
        assertEq(testPolls.isUserMemberOfGroup(group), false);
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(1);
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(2);
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(3);
        uint [] memory groupsOne = testPolls.getGroupsUserIsMemberIn();
        assertEq(groupsOne.length, 3);
        vm.startPrank(user1);
        testPolls.removeGroupMembership(2);
        uint [] memory groups = testPolls.getGroupsUserIsMemberIn();
        assertEq(testPolls.getGroupsUserIsMemberIn()[0], 1);
        assertEq(testPolls.getGroupsUserIsMemberIn()[1], 3);
        assertEq(groups.length, 2);



        
    }
    function testGetGroupsUserIsMemberIn() public {
        uint [] memory groupsOne = testPolls.getGroupsUserIsMemberIn();
        assertEq(groupsOne.length, 0);
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(1);
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(4);
        uint [] memory groups = testPolls.getGroupsUserIsMemberIn();
        assertTrue(groups.length>0);
        assertEq(groups.length, 2);
        assertEq(testPolls.getGroupsUserIsMemberIn()[0], 1);
        assertEq(testPolls.getGroupsUserIsMemberIn()[1], 4);
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(3);
        assertEq(testPolls.getGroupsUserIsMemberIn()[2], 3);

    }   
}