// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Polls} from "../src/Polls.sol";

contract DeployPolls is Script {
    function run() external returns (Polls) {
        vm.startBroadcast();
        Polls polls = new Polls();
        vm.stopBroadcast();
        return polls;
    }
}