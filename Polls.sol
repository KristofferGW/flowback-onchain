pragma solidity ^0.8.0;

contract Polls {
    struct Poll {
        string title;
        string tag;
        uint pollStartDate;
        uint proposalEndDate;
        uint votingStartDate;
        uint delegateEndDate;
        uint endDate;
        uint pollId;
    }
    
}