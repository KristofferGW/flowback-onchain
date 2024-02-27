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
        uint expectedGroup = 1;
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

    function testAddProposal() public {
        testPolls.createPoll("Sample poll", "Sample tag", 1, 1708672110, 1708672110 + 1 days, 1708672110 + 2 days, 1708672110 + 3 days, 1708672110 + 4 days);
        vm.expectEmit();
        string memory expectedDescription = "Test proposal";
        emit ProposalAdded(1, 1, "Test proposal");
        testPolls.addProposal(1, expectedDescription);
        Poll memory pollNumberOne = testPolls.getPoll(1);
        Proposal[] memory proposalsPollOne = testPolls.getProposals(1);
        assertEq(pollNumberOne.proposalCount, 1);
        assertEq(proposalsPollOne[0].description, expectedDescription);
        assertEq(proposalsPollOne[0].voteCount, 0);
        assertEq(proposalsPollOne[0].proposalId, 1);
        assertEq(proposalsPollOne[0].predictionCount, 0);
    }

    function testGetPollResults() public {
        string memory expectedDescriptionOne = "Test proposal";
        string memory expectedDescriptionTwo = "Test proposal 2";
        testPolls.createPoll("Sample poll", "Sample tag", 1, 1708672110, 1708672110 + 1 days, 1708672110 + 2 days, 1708672110 + 3 days, 1708672110 + 4 days);
        testPolls.addProposal(1, expectedDescriptionOne);
        testPolls.addProposal(1, expectedDescriptionTwo);
        testPolls.becomeMemberOfGroup(1);
        testPolls.vote(1, 2);
        (string[] memory proposalDescriptions, uint[] memory voteCounts) = testPolls.getPollResults(1);
        assertEq(proposalDescriptions[0], expectedDescriptionOne);
        assertEq(proposalDescriptions[1], expectedDescriptionTwo);
        assertEq(voteCounts[0], 0);
        assertEq(voteCounts[1], 1);
    }

}