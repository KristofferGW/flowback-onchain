// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title RightToVote
 * @dev A contract that manages the right to vote for different groups.
 * @author @EllenLng, @KristofferGW
 */
contract RightToVote {

    // A struct that represents a voter
    struct Voter{
        address publicKey; // The public key of the voter.
        uint[] groups; // An array of group IDs that the voter has permission to vote in.
    }

    // A mapping that maps a voter's address to a Voter struct.
    mapping(address => Voter) internal voters;

    event PermissionGivenToVote(uint indexed _group); // Event triggered when permission to vote is given for a group.

    /**
     * @dev Gives permission to vote in a group.
     * @param _group The group ID to give permission to vote in. 
    */
    function becameMemberOfGroup (uint _group) public payable {
        require(!isUserMemberOfGroup(_group), "You are already member of specified group");
        voters[msg.sender].groups.push(_group);
        emit PermissionGivenToVote(_group);
    }
    
    function indexOfGroup(uint[] memory groups, uint searchFor) internal pure returns (uint index) {
        for (uint i; i < groups.length;) {
            if (groups[i] == searchFor) {
                return i;
            }
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @dev Removes permission to vote in a group.
     * @param _group The group ID to remove permission to vote in.
    */
    function removeGroupMembership (uint _group) public payable {
        require(isUserMemberOfGroup(_group), "You are not member of specified group");
        uint index = indexOfGroup(voters[msg.sender].groups, _group);
        require(index < voters[msg.sender].groups.length, "index out of bound");

        for (uint i = index; i < voters[msg.sender].groups.length - 1;) {
            voters[msg.sender].groups[i] = voters[msg.sender].groups[i+1];
            unchecked {
                ++i;
            }
        }
        voters[msg.sender].groups.pop();
    }
    
    /**
     * @dev Checks if a user has permission to vote in a group.
     * @param _group The group ID to check.
     * @return hasRight Returns true if the user has permission to vote in the group, false otherwise.
    */
    function isUserMemberOfGroup(uint _group) public view returns (bool hasRight) {
        for (uint i; i < voters[msg.sender].groups.length;) {
            if (voters[msg.sender].groups[i] == _group) {
                return true;
            }
            unchecked {
                ++i;
            }
        }
    return false;
    }

    /**
     * @dev Retrieves all groups that the user has permission to vote in. 
     * @return groups Returns an array of group IDs that the user has permission to vote in.
    */
    function getGroupsUserIsMemberIn() public view returns (uint[] memory groups) {
        return voters[msg.sender].groups; 
    }
}