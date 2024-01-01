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

    event PermissionToVoteRemoved(uint indexed _group); // Event triggered when permission to vote is removed for a group.
    event PermissionGivenToVote(uint indexed _group); // Event triggered when permission to vote is given for a group.

    /**
     * @dev Checks if permission doesn't exist for a given group.
     * @param group The group ID to check.
     * @return permissionAlreadyExist Returns true if permission doesn't exist, false otherwise.
     */
    function permissionDoesntExist (uint group) internal view returns(bool permissionAlreadyExist){
        uint[] memory groups = voters[msg.sender].groups;
        for (uint i; i < groups.length;) {
            if (groups[i] == group) {
                return false;
            }
            unchecked {
                ++i;
            }  
        }
        return true;
    }

    /**
     * @dev Gives permission to vote in a group.
     * @param _group The group ID to give permission to vote in. 
    */
    function giveRightToVote (uint _group) public payable {
        require(permissionDoesntExist(_group), "Permission is already given in group");
        voters[msg.sender].groups.push(_group);
        emit PermissionGivenToVote(_group);
    }

    /**
     * @dev Finds the index of a group in an array of groups.
     * @param groups The array of group IDs to search in.
     * @param searchFor The group ID to search for.
     * @return hasDelegated Returns true if the user has delegated in the group, false otherwise.
    */
    function indexOfGroup(uint[] memory groups, uint searchFor) internal pure returns (uint256) {
        for (uint i; i < groups.length;) {
            if (groups[i] == searchFor) {
                return i;
            }

            unchecked {
                ++i;
            }
        }
        revert("Not Found");
    }

    /**
     * @dev Removes permission to vote in a group.
     * @param _group The group ID to remove permission to vote in.
    */
    function removeRightToVote (uint _group) public payable {
        require(!permissionDoesntExist(_group), "Can't find group you are trying to remove");
        uint index = indexOfGroup(voters[msg.sender].groups, _group);
        require(index < voters[msg.sender].groups.length, "index out of bound");

        for (uint i = index; i < voters[msg.sender].groups.length - 1;) {
            voters[msg.sender].groups[i] = voters[msg.sender].groups[i+1];
            unchecked {
                ++i;
            }
        }
        voters[msg.sender].groups.pop();
        emit PermissionToVoteRemoved(_group);

    }
    
    /**
     * @dev Checks if a user has permission to vote in a group.
     * @param _group The group ID to check.
     * @return hasRight Returns true if the user has permission to vote in the group, false otherwise.
    */
    function checkRightsInGroup (uint _group) public view returns (bool hasRight) {
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
    function checkAllRights () public view returns (uint[] memory groups) {
        return  voters[msg.sender].groups; 
    }
}