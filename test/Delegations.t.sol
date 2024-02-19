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
    function testEmitNewDelegation() public {
        address[] memory addresses;
        address addr = 0x0000000000000000000000000000000000000001;
        addresses[0] = addr;
        vm.startPrank(user2);
        testPolls.becameMemberOfGroup(_groupId);
        vm.startPrank(user2);
        testPolls.becomeDelegate(_groupId);
    //   vm.stopPrank();
        vm.startPrank(user1);
        testPolls.becameMemberOfGroup(_groupId);
        vm.startPrank(user1);
        testPolls.becomeDelegate(_groupId);
        vm.expectEmit();
        emit NewDelegation(user1, user2, _groupId, 1, addresses); 
        testPolls.delegate(1, user2);  

//         [FAIL. Reason: panic: array out-of-bounds access (0x32)] testEmitNewDelegation() (gas: 341)
// Traces:
//   [3271429] DelegationsTest::setUp()
//     ├─ [3213355] → new Polls@0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
//     │   └─ ← 16049 bytes of code
//     └─ ← ()

//   [341] DelegationsTest::testEmitNewDelegation()
//     └─ ← panic: array out-of-bounds access (0x32)
        
    }
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

    //private functions (passed testing) ------------------------------------------------------------

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
    //     // vm.stopPrank();
    //     assertEq(testPolls.addressIsDelegate(1, user1), false);
    // }
}