// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RightToVote {

    struct Voter{
        address publicKey;
        uint[] groups;
        bool hasDelegated;
    }

    mapping(address => Voter) internal voters;
    
    function giveRightToVote (uint _group) public payable {
        voters[msg.sender].groups.push(_group);
    }

    function indexOfGroup(uint[] memory groups, uint searchFor) internal pure returns (uint256) {
        for (uint i = 0; i < groups.length; i++) {
            if (groups[i] == searchFor) {
            return i;
            }
        }
        revert("Not Found");
    }

    function removeRightToVote (uint _group) public payable {
        uint index = indexOfGroup(voters[msg.sender].groups, _group);
        require(index<voters[msg.sender].groups.length, "index out of bound");

        for (uint i = index; i < voters[msg.sender].groups.length - 1; i++) {
            voters[msg.sender].groups[i] = voters[msg.sender].groups[i+1];
        }
        voters[msg.sender].groups.pop();

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