// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "../src/Polls.sol";

contract PollsTest is Test {
    Polls polls;

    function testCreatePoll() public {
        polls = new Polls();
        polls.createPoll(
            "Will polls work?", 
            "Testing", 
            1, 
            block.timestamp, 
            block.timestamp + 1 days,
            block.timestamp + 2 days,
            block.timestamp + 2 days,
            block.timestamp + 3 days 
            );

        assertEq(pollCount, 1);
    }
}