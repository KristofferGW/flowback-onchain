// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "src/Polls.sol";


contract DelegationsTest is Test, Polls {
    
    Polls public testPolls;
    address user1 = address(0x1);
    address user2 = address(0x2);
    uint _groupId = 1;

    function setUp() public {
        testPolls = new Polls();
    }

    function run() public {
        vm.broadcast();
    }

    function testEmitNewDelegate() public {
        uint groupDelegateCount = 1;
        vm.startPrank(user1);
        vm.expectEmit();
        emit NewDelegate(user1, _groupId, 0, new address[](0), groupDelegateCount);
        testPolls.becomeDelegate(_groupId);
    }

    function testEmitDelegateResignation() public {
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(_groupId);
        vm.startPrank(user1);
        testPolls.becomeDelegate(_groupId);
        // vm.stopPrank();
        vm.expectEmit();
        emit DelegateResignation(user1, _groupId);
        testPolls.resignAsDelegate(_groupId);
    }


// [FAIL. Reason: panic: array out-of-bounds access (0x32)]-----------------------------------------

    // function testEmitNewDelegation() public {
    //     address[] memory addresses;
    //     address addr = 0x0000000000000000000000000000000000000003;
    //     addresses[1] = addr;
    //     vm.startPrank(user2);
    //     testPolls.becomeMemberOfGroup(_groupId);
    //     vm.startPrank(user2);
    //     testPolls.becomeDelegate(_groupId);
    // //   vm.stopPrank();
    //     vm.startPrank(user1);
    //     testPolls.becomeMemberOfGroup(_groupId);
    //     vm.startPrank(user1);
    //     testPolls.becomeDelegate(_groupId);
    //     vm.expectEmit();
    //     emit NewDelegation(user1, user2, _groupId, 1, groupDelegates[_groupId][0].delegationsFrom);
    //     vm.startPrank(user1);
    //     testPolls.delegate(1, user2);  
        
    // }

    function testDelegate() public {
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(_groupId);
        vm.startPrank(user1);
        testPolls.becomeDelegate(_groupId);
        vm.startPrank(user2);
        testPolls.becomeDelegate(_groupId);
        Polls.GroupDelegate[] memory delegates = groupDelegates[_groupId];
        for (uint i = 0; i < delegates.length; i++) {
            assertEq(delegates[i].delegatedVotes, 0);
        }
        vm.startPrank(user1);
        testPolls.delegate(1, user2);
        // assertEq(delegates[0].delegatedVotes, 1) ;
        //  assertEq(groupDelegates[_groupId][0].delegatedVotes, 1);
       
    }

    // function testRemoveDelegation() public {
    //     vm.startPrank(user1);
    //     testPolls.becomeMemberOfGroup(_groupId);
    //     vm.startPrank(user1);
    //     testPolls.becomeDelegate(_groupId);
    //     vm.startPrank(user2);
    //     testPolls.becomeDelegate(_groupId);
    //     vm.startPrank(user1);
    //     testPolls.delegate(1, user2); 
    //     assertEq(groupDelegates[_groupId][0].delegatedVotes, 1);
    //     vm.startPrank(user1);
    //     testPolls.removeDelegation(groupDelegates[_groupId][0].delegate, _groupId);
    //     assertEq(groupDelegates[_groupId][0].delegatedVotes, 0);
    // }

    // function testHasDelegatedToDelegateInGroup() public {
    //     vm.startPrank(user1);
    //     testPolls.becomeMemberOfGroup(_groupId);
    //     vm.startPrank(user1);
    //     testPolls.becomeDelegate(_groupId);
    //     vm.startPrank(user2);
    //     testPolls.becomeDelegate(_groupId);
    //     vm.startPrank(user1);
    //     testPolls.delegate(1, user2); 
    //     assertEq(groupDelegates[_groupId][0].delegatedVotes, 1);
    //     assertTrue(testPolls.hasDelegatedToDelegateInGroup(_groupId, user1));
    // }

    // private functions (passed testing) ------------------------------------------------------------

    // function testBecomeDelegate() public{
    //     vm.startPrank(user1);
    //     testPolls.becomeDelegate(1);
    //     assertEq(testPolls.addressIsDelegate(1, user1), true); 
    // }

    // function testResignAsDelegate() public {
    //     vm.startPrank(user1);
    //     testPolls.becameMemberOfGroup(_groupId);
    //     vm.startPrank(user1);
    //     testPolls.becomeDelegate(_groupId);
    //     assertEq(testPolls.addressIsDelegate(1, user1), true);
    //     vm.startPrank(user1);
    //     testPolls.resignAsDelegate(_groupId);
    //     vm.stopPrank();
    //     assertEq(testPolls.addressIsDelegate(1, user1), false);
    // }

}