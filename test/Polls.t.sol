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
        string memory pollTitle = "Test title";
        string memory tag = "Test tag";
        uint group = 1;
        uint pollStartDate = 1709712019;
        uint proposalEndDate = 1709712019 + 3 days;
        uint votingStartDate = 1709712019;
        uint delegateEndDate = 1709712019 + 3 days;
        uint endDate = 1709712019 + 5 days;
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
}