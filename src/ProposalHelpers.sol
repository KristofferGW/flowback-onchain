// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {PollHelpers} from './PollHelpers.sol';

contract ProposalHelpers is PollHelpers {

    struct Proposal {
        string description;
        uint voteCount;
        uint proposalId;
        uint predictionCount;
    }

    //Ties proposals to polls by pollId
    mapping(uint => Proposal[]) public proposals;
}