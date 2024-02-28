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

    function testVote() public {
        testPolls.createPoll("Sample poll", "Sample tag", 1, 1708672110, 1708672110 + 1 days, 1708672110 + 2 days, 1708672110 + 3 days, 1708672110 + 4 days);
        testPolls.addProposal(1, "Test proposal");
        testPolls.addProposal(1, "Test proposal 2");
        testPolls.becomeMemberOfGroup(1);
        vm.warp(1708675110);
        testPolls.vote(1, 2);
        (string[] memory proposalDescriptions, uint[] memory voteCounts) = testPolls.getPollResults(1);
        assertEq(voteCounts[1], 1);
        vm.startPrank(address(0x1));
        vm.warp(1708672110 + 5 days);
        testPolls.becomeMemberOfGroup(1);
        vm.expectRevert(bytes("Voting is not allowed at this time"));
        testPolls.vote(1, 2);
        vm.stopPrank();
        vm.startPrank(address(0x2));
        vm.expectRevert(bytes("The user is not a member of poll group"));
        testPolls.vote(1, 1);
        vm.stopPrank();
        vm.warp(1708675110);
        vm.expectRevert(bytes("Vote has already been cast"));
        testPolls.vote(1, 2);
        vm.startPrank(address(0x1));
        testPolls.becomeDelegate(1);
        vm.stopPrank();
        vm.startPrank(address(0x2));
        testPolls.becomeMemberOfGroup(1);
        testPolls.delegate(1, address(0x1));
        vm.expectRevert(bytes("You have delegated your vote in the polls group."));
        testPolls.vote(1, 1);
        vm.stopPrank();
        vm.startPrank(address(0x1));
        testPolls.vote(1, 2);
        (string[] memory proposalDescriptionsTwo, uint[] memory voteCountsTwo) = testPolls.getPollResults(1);
        assertEq(voteCountsTwo[1], 3);
    }

}