// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "src/RightToVote.sol";
// import "src/Delegations.sol";
// import "src/Polls.sol";
// import "src/Predictions.sol";

// contract TestFlowback is Test {
//     RightToVote rightToVote;
//     Delegations delegations;
//     Polls polls;
//     Predictions predictions;
//     address user = address(0x1);
//     address user1 = address(0x2);

//     function setUp() public {
//         rightToVote = new RightToVote();
//         delegations = new Delegations();
//         polls = new Polls();
//         predictions = new Predictions();
//     }

//     /////////// Basic Tests ///////////

//     // RightToVote
//     function testCheckRightsInGroup() public {
//         rightToVote.becomeMemberOfGroup(1);
//         assertTrue(rightToVote.checkRightsInGroup(1));
//     }

//     function testCheckAllRights() public {
//         rightToVote.giveRightToVote(1);
//         rightToVote.giveRightToVote(2);
//         assertEq(rightToVote.checkAllRights().length, 2);
//     }

//     function testRemoveRightToVote() public {
//         rightToVote.giveRightToVote(1);
//         rightToVote.removeRightToVote(1);
//         assertEq(rightToVote.checkAllRights().length, 0);
//     }


//     // Delegations
//     // function testBecomeDelegate() public {
//     //     vm.startPrank(user);
//     //     delegations.becomeDelegate(1);
//     //     assertEq(delegations.addressIsDelegate(1, user), true);
//     // } 

//     // function testResignAsDelegate() public {
//     //     vm.startPrank(user);
//     //     delegations.becomeDelegate(1);
//     //     delegations.resignAsDelegate(1);
//     //     assertEq(delegations.addressIsDelegate(1, user), false);
//     // }

//     // Polls
//     function testCreatePoll() public {
//         polls.createPoll("title", "tag", 1, 1, 1, 1, 1, 1);
//         assertEq(polls.pollCount(), 1);
//     }

//     // function testAddProposal() public {
//     //     polls.createPoll("title", "tag", 1, 1, 1, 1, 1, 1);
//     //     polls.addProposal(1, "description");
//     //     assertEq(polls.getProposalCount(1), 1);
//     //}
// }