// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {Test, console} from 'forge-std/Test.sol';
import {Polls} from '../src/Polls.sol';
import {DeployPolls} from '../script/DeployPolls.s.sol';

contract TestPolls is Test {
    Polls polls;

    // string calldata _title,
    //     string calldata _tag,
    //     uint _group,
    //     uint _pollStartDate,
    //     uint _proposalEndDate,
    //     uint _votingStartDate, 
    //     uint _delegateEndDate,
    //     uint _endDate,
    //     uint _maxVoteScore

    string BASIC_POLL_TITLE = "What should we have for dinner?";
    string BASIC_POLL_TAG = "Food choices";
    string BASIC_POLL_GROUP = "Foodies";
    uint256 BASIC_POLL_START_DATE = block.timestamp;
    uint256 BASIC_POLL_PROPOSAL_END_DATE = block.timestamp + 3 days;
    uint256 BASIC_POLL_VOTING_START_DARTE = block.timestamp;
    uint256 BASIC_POLL_DELEGATE_END_DATE = block.timestamp + 1 days;
    uint256 BASIC_POLL_END_DATE = block.timestamp + 5 days;
    uint256 MAX_VOTE_SCORE = 100;

    function setUp() external {
        DeployPolls deployPolls = new DeployPolls();
        polls = deployPolls.run();
    }

    modifier basicPollSetup() {

    }
}