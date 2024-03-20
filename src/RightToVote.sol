// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title RightToVote
 * @dev A contract that manages the right to vote for different groups.
 */
contract RightToVote {
    // Represents a voter
    struct Voter {
        mapping(uint => bool) isMemberOfGroup; // Mapping of group IDs to membership status
        uint[] memberGroups;  // Array to keep track of the groups a user is a member of
    }

    // Maps a voter's address to a Voter struct
    mapping(address => Voter) private voters;

    // Event triggered when a user joins or leaves a group
    event GroupMembershipChanged(address indexed user, uint indexed group, bool isMember);

    /**
     * @dev Join a group.
     * @param _group The group ID to join.
     */
    function becomeMemberOfGroup(uint _group) public {
        require(!voters[msg.sender].isMemberOfGroup[_group], "Already a member of this group");
        voters[msg.sender].isMemberOfGroup[_group] = true;
        voters[msg.sender].memberGroups.push(_group);
        emit GroupMembershipChanged(msg.sender, _group, true);
    }

    /**
     * @dev Leave a group.
     * @param _group The group ID to leave.
     */
    function removeGroupMembership(uint _group) public {
        require(voters[msg.sender].isMemberOfGroup[_group], "Not a member of this group");

        // Remove the group from the memberGroups array
        uint index;
        for (index = 0; index < voters[msg.sender].memberGroups.length; index++) {
            if (voters[msg.sender].memberGroups[index] == _group) {
                break;
            }
        }
        require(index < voters[msg.sender].memberGroups.length, "Group not found");
        for (; index < voters[msg.sender].memberGroups.length - 1; index++) {
            voters[msg.sender].memberGroups[index] = voters[msg.sender].memberGroups[index + 1];
        }
        voters[msg.sender].memberGroups.pop();
        voters[msg.sender].isMemberOfGroup[_group] = false;
        
        emit GroupMembershipChanged(msg.sender, _group, false);
    }

    /**
     * @dev Check if a user is a member of a group.
     * @param _group The group ID to check.
     * @return isMember Returns true if the user is a member of the group, false otherwise.
     */
    function isUserMemberOfGroup(uint _group) public view returns (bool isMember) {
        return voters[msg.sender].isMemberOfGroup[_group];
    }
    
    /**
     * @dev Retrieves all groups that the user is a member of.
     * @return memberGroups An array of group IDs that the user is a member of.
     */
    function getGroupsUserIsMemberIn() public view returns (uint[] memory) {
        return voters[msg.sender].memberGroups;
    }
}