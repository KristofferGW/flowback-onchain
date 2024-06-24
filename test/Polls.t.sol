// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {Test, console} from 'forge-std/Test.sol';
import {Polls} from '../src/Polls.sol';
import {DeployPolls} from '../script/DeployPolls.s.sol';

contract TestPolls is Test {
    Polls polls;

    function setUp() external {
        DeployPolls deployPolls = new DeployPolls();
        polls = deployPolls.run();
    }
}