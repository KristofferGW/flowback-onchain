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
    // function testEmitNewDelegation() public {
    //     address[] memory addresses;
    //     addresses[0] = 0x0000000000000000000000000000000000000001;
    //     vm.startPrank(user2);
    //     testPolls.becameMemberOfGroup(_groupId);
    //     vm.startPrank(user2);
    //     testPolls.becomeDelegate(_groupId);
    // //   vm.stopPrank();
    //     vm.startPrank(user1);
    //     testPolls.becameMemberOfGroup(_groupId);
    //     vm.startPrank(user1);
    //     testPolls.becomeDelegate(_groupId);
        
    //     vm.expectEmit();
    //     emit NewDelegation(user1, user2, _groupId, 1, addresses[0]); //need FIX
    //     testPolls.delegate(1, user2);  
    // }
    function testEmitDelegateResignation() public {
        vm.startPrank(user1);
        testPolls.becameMemberOfGroup(_groupId);
        vm.startPrank(user1);
        testPolls.becomeDelegate(_groupId);
        // vm.stopPrank();
        vm.expectEmit();
        emit DelegateResignation(user1, _groupId);
        testPolls.resignAsDelegate(_groupId);
    }
    
}