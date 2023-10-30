// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RightToVote {

    struct Voter{
        address publicKey;
        uint[] groups;
    }

    mapping(address => Voter) internal Voters;
    
    function giveRightToVote (uint _group) public payable {
        Voters[msg.sender].groups.push(_group);
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
        uint index = indexOfGroup(Voters[msg.sender].groups, _group);
        require(index<Voters[msg.sender].groups.length, "index out of bound");

        for (uint i = index; i < Voters[msg.sender].groups.length - 1; i++) {
            Voters[msg.sender].groups[i] = Voters[msg.sender].groups[i+1];
        }
        Voters[msg.sender].groups.pop();

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