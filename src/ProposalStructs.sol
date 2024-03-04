// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {PollStructs} from './PollStructs.sol';

contract ProposalStructs is PollStructs {

    struct Proposal {
        string description;
        uint voteCount;
        uint proposalId;
        uint predictionCount;
        PollPhase phase;
    }

    //Ties proposals to polls by pollId
    mapping(uint => Proposal[]) public proposals;
}