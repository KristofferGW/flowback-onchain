// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Polls.sol";

contract PollsTest is Test, Polls {

    Polls public testPolls;

    function setUp() public {
        testPolls = new Polls();
    }

    function run() public {
        vm.broadcast(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);
    }

    function testEmitPollCreated() public {
        vm.expectEmit();
        emit PollCreated(1, "new poll");
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
    }

    // function testCreatePoll() public {
    //     testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
    //     // testPolls.polls[] pollss = [
    //     //     {
    //     //         title: "new poll", 
    //     //         tag: "tag", 
    //     //         group: 1, 
    //     //         pollStartDate:1, 
    //     //         proposalEndDate: 1, 
    //     //         votingStartDate:1, 
    //     //         delegateEndDate: 1, 
    //     //         endDate: 1
    //     //     }];
    //     assertEq(pollss, testPolls.polls);
        
    // }

    // function testRequirePollToExist(uint pollId) public {

    //         //vm.prank(0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD);
    //         vm.expectRevert(bytes("State not set correctly for continuation")); 
    //         testPolls.requirePollToExist(pollId);
    // }

    function testEmitAddProposal() public {
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
        vm.expectEmit();
        emit ProposalAdded(1, 1, "new proposal");
        testPolls.addProposal(1, "new proposal");
    }

    // function testAddProposal() public {
    //     testPolls.addProposal(1,"new proposal");
    // }

    // function testGetProposals(uint pollId) public {
    //     testPolls.AddProposal(1, "new proposal");
    //     testPolls.proposals [] proposals = [
    //         {
    //             description: "new proposal",
    //             voteCount: 0,
    //             proposalId: 1,
    //             predictionCount: 0,
    //             phase: PollPhase.predictionPhase
    //         }
    //     ]

    //     expectEq(testPolls.proposals, proposals)
    // }
    // function testGetPollResult(uint pollId) public {


    // }

}