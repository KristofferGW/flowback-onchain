// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RightToVote {

    struct Voter{
        address publicKey;
        uint[] groups;
    }

    mapping(address => Voter) internal voters;
    
    function giveRightToVote (uint _group) public payable {
        voters[msg.sender].groups.push(_group);
    }

    function checkRightsInGroup (uint _group) public view returns (bool hasRight) {
    for (uint i = 0; i < voters[msg.sender].groups.length; i++) {
        if (voters[msg.sender].groups[i] == _group) {
            return true;
        }
    }
    return false;
    }

    function checkAllRights () public view returns (uint[] memory groups) {
        return  voters[msg.sender].groups; 
    }

}