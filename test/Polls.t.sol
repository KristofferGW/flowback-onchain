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

    // function testRequirePollToExist(uint pollId) public {
    //         assertFalse(testPolls.requireProposalToExist(_pollId, _proposalId));
    // -----   internal function  -----
    // }

    function testEmitAddProposal() public {
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
        vm.expectEmit();
        emit ProposalAdded(1, 1, "new proposal");
        testPolls.addProposal(1, "new proposal");
    }


    function testCreatePoll() public {
        testPolls.createPoll("title", "tag", 1, 1, 1, 1, 1, 1);
        assertEq(testPolls.pollCount(), 1);
    }

    function testAddProposal() public {
        testPolls.createPoll("title", "tag", 1, 1, 1, 1, 1, 1);
        testPolls.addProposal(1, "description");
        Polls.Proposal[] memory propos = testPolls.getProposals(1);
        assertEq(propos.length, 1);
    }

    function testGetProposals() public {
        testPolls.createPoll("title", "tag", 1, 1, 1, 1, 1, 1);
        testPolls.addProposal(1, "description");
        // Polls.Proposal[] memory propos = testPolls.getProposals(1);
        // assertEq(testPolls.proposals, propos);
    }
    // function testGetPollResult(uint pollId) public {


    // }

}