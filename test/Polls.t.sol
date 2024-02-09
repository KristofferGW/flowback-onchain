// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Polls.sol";

contract PollsTest is Test, Polls {

    Polls public testPolls;

    function setUp() public {
        testPolls = new Polls();
    }

    function run() public {
        vm.broadcast();
    }

    function testEmitPollCreated() public {
        
        vm.expectEmit();

        emit PollCreated(1, "new poll");
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
    }

    function testCreatePoll() public {
        testPolls.createPoll("new poll", "tag", 1, 1, 1, 1, 1, 1);
        testPolls.polls[] pollss = [
            {
                title: "new poll", 
                tag: "tag", 
                group: 1, 
                pollStartDate:1, 
                proposalEndDate: 1, 
                votingStartDate:1, 
                delegateEndDate: 1, 
                endDate: 1
            }];
        

       
    
     
        assertEq(pollss, testPolls.polls);
        
    }
    
}