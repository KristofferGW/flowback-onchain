// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Polls.sol";

contract PollsTest is Test, Polls {

    Polls public testPolls;

    function setUp() public {
        testPolls = new Polls();
    }

    function testCreatePoll() public {
        vm.expectEmit();
        emit PollCreated(1, "Sample poll");
        uint initialPollCount = testPolls.pollCount();
        string memory expectedTitle = "Sample poll";
        string memory expectedTag = "test";
        uint expectedGroup = 1; // why not memory?
        uint expectedPollStartDate = 1708672110;
        uint expectedProposalEndDate = 1708672110 + 1 days;
        uint expectedVotingStartDate = 1708672110 + 2 days;
        uint expectedDelegateEndDate = 1708672110 + 3 days;
        uint expectedEndDate = 1708672110 + 4 days;
        testPolls.createPoll(expectedTitle, expectedTag, expectedGroup, expectedPollStartDate, expectedProposalEndDate, expectedVotingStartDate, expectedDelegateEndDate, expectedEndDate);
        uint finalPollCount = testPolls.pollCount();
        Poll memory createdPoll = testPolls.getPoll(initialPollCount + 1);
        assertEq(finalPollCount, initialPollCount + 1);
        assertEq(createdPoll.title, expectedTitle);
        assertEq(createdPoll.tag, expectedTag);
        assertEq(createdPoll.group, expectedGroup);
        assertEq(createdPoll.pollStartDate, expectedPollStartDate);
        assertEq(createdPoll.proposalEndDate, expectedProposalEndDate);
        assertEq(createdPoll.votingStartDate, expectedVotingStartDate);
        assertEq(createdPoll.delegateEndDate, expectedDelegateEndDate);
        assertEq(createdPoll.endDate, expectedEndDate);
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


    // function testCreatePoll() public {
    //     testPolls.createPoll("title", "tag", 1, 1, 1, 1, 1, 1);
    //     assertEq(testPolls.pollCount(), 1);
    // }

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