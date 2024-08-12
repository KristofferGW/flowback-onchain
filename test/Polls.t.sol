// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {Test, console} from 'forge-std/Test.sol';
import {Polls} from '../src/Polls.sol';
import {DeployPolls} from '../script/DeployPolls.s.sol';
import {PollHelpers} from '../src/PollHelpers.sol';

contract TestPolls is Test, Polls {
    Polls testPolls;

    string BASIC_POLL_TITLE = "What should we have for dinner?";
    string BASIC_POLL_TAG = "Food choices";
    uint256 BASIC_POLL_GROUP = 1;
    uint256 BASIC_POLL_START_DATE = block.timestamp;
    uint256 BASIC_POLL_PROPOSAL_END_DATE = block.timestamp + 3 days;
    uint256 BASIC_POLL_VOTING_START_DARTE = block.timestamp + 12 hours;
    uint256 BASIC_POLL_DELEGATE_END_DATE = block.timestamp + 1 days;
    uint256 BASIC_POLL_END_DATE = block.timestamp + 5 days;

    function setUp() external {
        DeployPolls deployPolls = new DeployPolls();
        testPolls = deployPolls.run();
    }

    modifier createPollWithZeroMaxScore() {
        testPolls.createPoll(
            BASIC_POLL_TITLE,
            BASIC_POLL_TAG,
            BASIC_POLL_GROUP,
            BASIC_POLL_START_DATE,
            BASIC_POLL_PROPOSAL_END_DATE,
            BASIC_POLL_VOTING_START_DARTE,
            BASIC_POLL_DELEGATE_END_DATE,
            BASIC_POLL_END_DATE,
            0
            );
        _;
    }

    modifier createPollWithOneHundredMaxScore() {
        testPolls.createPoll(
            BASIC_POLL_TITLE,
            BASIC_POLL_TAG,
            BASIC_POLL_GROUP,
            BASIC_POLL_START_DATE,
            BASIC_POLL_PROPOSAL_END_DATE,
            BASIC_POLL_VOTING_START_DARTE,
            BASIC_POLL_DELEGATE_END_DATE,
            BASIC_POLL_END_DATE,
            100
            );
        _;
    }

    modifier addProposalAndBecomeMemberOfGroup() {
        vm.warp(block.timestamp + 1 days);
        testPolls.addProposal( {_pollId: 1, _description: "Pizza"} );
        testPolls.becomeMemberOfGroup({ _group: 1 });
        _;
    }

    function voteWithZeroScore() internal {
        testPolls.vote({ _pollId: 1, _proposalId: 1, _score: 0 });
    }

    function testAddProposalAfterEndDate() public createPollWithOneHundredMaxScore {
        vm.warp(block.timestamp + 4 days);
        vm.expectRevert("The proposal phase has ended.");
        testPolls.addProposal( {_pollId: 1, _description: "Pizza"} );
    }

    function testCreatePollWithInvalidMaxScore() public {
        vm.expectRevert("Max vote score must be betweeen 0 and 100");
        testPolls.createPoll(
            BASIC_POLL_TITLE,
            BASIC_POLL_TAG,
            BASIC_POLL_GROUP,
            BASIC_POLL_START_DATE,
            BASIC_POLL_PROPOSAL_END_DATE,
            BASIC_POLL_VOTING_START_DARTE,
            BASIC_POLL_DELEGATE_END_DATE,
            BASIC_POLL_END_DATE,
            101
        );
    }

    function testCreatePollWithOneHundredMaxScore() public createPollWithOneHundredMaxScore {
        PollHelpers.Poll memory currentPoll = testPolls.getPoll(BASIC_POLL_GROUP);
        assertEq(currentPoll.maxVoteScore, 100);
    }

    function testCreatePollWithZeroScore() public createPollWithZeroMaxScore {
        PollHelpers.Poll memory currentPoll = testPolls.getPoll(BASIC_POLL_GROUP);
        assertEq(currentPoll.maxVoteScore, 0);
    }

    function testDoubleVoting() public createPollWithZeroMaxScore addProposalAndBecomeMemberOfGroup {
        voteWithZeroScore();
        vm.expectRevert();
        voteWithZeroScore();
    }

    function testVotingBeforeVotingIsOpen() public createPollWithOneHundredMaxScore {
        vm.warp(block.timestamp + 1 hours);
        testPolls.becomeMemberOfGroup({ _group: 1 });
        testPolls.addProposal( {_pollId: 1, _description: "Pizza"} );
        vm.warp(block.timestamp + 1 hours);
        vm.expectRevert("Voting is not allowed at this time");
        testPolls.vote({ _pollId: 1, _proposalId: 1, _score: 50 });
    }

    function testVotingWithInvalidScore() public createPollWithOneHundredMaxScore addProposalAndBecomeMemberOfGroup {
        vm.expectRevert("Vote score must be between 0 and max score");
        testPolls.vote({ _pollId: 1, _proposalId: 1, _score: 101 });
    }

    function testVotingWithScore() public createPollWithOneHundredMaxScore addProposalAndBecomeMemberOfGroup {
        testPolls.vote({ _pollId: 1, _proposalId: 1, _score: 50 });
        Proposal[] memory pollProposals = testPolls.getProposals(1);
        uint scoreOfProposal = pollProposals[0].score;
        assertEq(scoreOfProposal, 50);
    }

    function testVotingWithZeroScore() public createPollWithZeroMaxScore addProposalAndBecomeMemberOfGroup {
        voteWithZeroScore();
        Proposal[] memory pollProposals = testPolls.getProposals(1);
        uint scoreOfProposal = pollProposals[0].score;
        assertEq(scoreOfProposal, 0);
    }
}