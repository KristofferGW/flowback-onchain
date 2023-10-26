// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RightToVote {

    struct Voter{
        address publicKey;
        uint[] groups;
        bool hasRightToVote;
    }

    mapping(address => Voter) internal Voters;
    
    function giveRightToVote (uint _group) public payable {
        Voters[msg.sender].groups.push(_group);
        Voters[msg.sender].hasRightToVote = true;
    }

    function checkRightsInGroup (uint _group) public view returns (bool hasRight) {
    for (uint i = 0; i < Voters[msg.sender].groups.length; i++) {
        if (Voters[msg.sender].groups[i] == _group) {
            return true;
        }
    }
    return false;
    }

    function checkAllRights () public view returns (uint[] memory groups) {
        return  Voters[msg.sender].groups; 
    }

}