// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {Test, console} from 'forge-std/Test.sol';
import {Polls} from '../src/Polls.sol';
import {DeployPolls} from '../script/DeployPolls.s.sol';
import {PollHelpers} from '../src/PollHelpers.sol';

contract TestPolls is Test {
    Polls polls;

    string BASIC_POLL_TITLE = "What should we have for dinner?";
    string BASIC_POLL_TAG = "Food choices";
    uint256 BASIC_POLL_GROUP = 1;
    uint256 BASIC_POLL_START_DATE = block.timestamp;
    uint256 BASIC_POLL_PROPOSAL_END_DATE = block.timestamp + 3 days;
    uint256 BASIC_POLL_VOTING_START_DARTE = block.timestamp;
    uint256 BASIC_POLL_DELEGATE_END_DATE = block.timestamp + 1 days;
    uint256 BASIC_POLL_END_DATE = block.timestamp + 5 days;

    function setUp() external {
        DeployPolls deployPolls = new DeployPolls();
        polls = deployPolls.run();
    }

    modifier createPollWithZeroMaxScore() {
        polls.createPoll(
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

    function testCreatePollWithZeroScore() public createPollWithZeroMaxScore {
        PollHelpers.Poll memory currentPoll = polls.getPoll(BASIC_POLL_GROUP);
        assertEq(currentPoll.maxVoteScore, 0);
    }
}