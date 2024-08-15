// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {Delegations} from "../src/Delegations.sol";
import {Polls} from "../src/Polls.sol";


contract DelegationsTest is Test, Delegations, Polls {
    
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

    modifier userOneBecomesDelegate() {
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(_groupId);
        testPolls.becomeDelegate(_groupId);
        vm.stopPrank();
        _;
    }

    function testEmitNewDelegate() public {
        vm.startPrank(user1);
        testPolls.becomeMemberOfGroup(_groupId);
        emit NewDelegate(user1, _groupId, 0, new address[](0), 1);
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

    function testBecomeDelegate() public userOneBecomesDelegate {
        bool userOneIsDelegate = testPolls.addressIsDelegate(_groupId, user1);
        assertEq(userOneIsDelegate, true);
    }

    function testDelegate() public userOneBecomesDelegate {
        vm.startPrank(user2);
        testPolls.becomeMemberOfGroup(_groupId);
        testPolls.delegate(_groupId, user1);
        bool userTwoDelegatedToUserOne = testPolls.hasDelegatedToDelegateInGroup(_groupId, user1);
        vm.stopPrank();
        assertEq(userTwoDelegatedToUserOne, true);    
    }

    function testRemoveDelegation() public userOneBecomesDelegate {
        vm.startPrank(user2);
        testPolls.becomeMemberOfGroup(_groupId);
        testPolls.delegate(_groupId, user1);
        testPolls.removeDelegation(user1, _groupId);
        bool userTwoDelegatedToUserOne = testPolls.hasDelegatedToDelegateInGroup(_groupId, user1);
        assertEq(userTwoDelegatedToUserOne, false);
    }
}