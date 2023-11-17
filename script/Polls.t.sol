// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Polls.sol";

contract PollsTest is Test, Polls {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    function testCreatePoll() public {
        
    }
    
}