// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Polls.sol";

contract PollsTest is Test, Polls {

    Polls public testPolls;
    string public pollTitle;
    string public tag;
    uint public group;
    uint public pollStartDate;
    uint public proposalEndDate;
    uint public votingStartDate;
    uint public delegateEndDate;
    uint public endDate;

    function setUp() public {
        testPolls = new Polls();
        pollTitle = "Test title";
        tag = "Test tag";
        group = 1;
        pollStartDate = 1709712019;
        proposalEndDate = 1709712019 + 3 days;
        votingStartDate = 1709712019;
        delegateEndDate = 1709712019 + 3 days;
        endDate = 1709712019 + 5 days;
    }

    function testCreatePoll() public {
        
        vm.expectEmit();
        emit PollCreated(1, pollTitle);
        testPolls.createPoll(pollTitle, tag, group, pollStartDate, proposalEndDate, votingStartDate, delegateEndDate, endDate);
        Poll memory createdPoll = testPolls.getPoll(1);
        assertEq(createdPoll.title, pollTitle);
        assertEq(createdPoll.group, group);
        assertEq(createdPoll.proposalEndDate, proposalEndDate);
        assertEq(createdPoll.votingStartDate, votingStartDate);
        assertEq(createdPoll.delegateEndDate, delegateEndDate);
        assertEq(createdPoll.endDate, endDate);
    }

    function testAddProposalHappyTrail() public {
        
    }
}