// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RightToVote {

    struct Voter{
        address publicKey;
        uint[] groups;
    }

    mapping(address => Voter) internal voters;

    event PermissionToVoteRemoved(uint indexed _group);
    event PermissionGivenToVote(uint indexed _group);

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

    
    function giveRightToVote (uint _group) public payable {
        require(permissionDoesntExist(_group), "Permission is already given in group");
        voters[msg.sender].groups.push(_group);
        emit PermissionGivenToVote(_group);
    }

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

    function removeRightToVote (uint _group) public payable {
        require(!permissionDoesntExist(_group), "Can't find group you are trying to remove");
                uint index = indexOfGroup(voters[msg.sender].groups, _group);
                require(index<voters[msg.sender].groups.length, "index out of bound");

                for (uint i = index; i < voters[msg.sender].groups.length - 1;) {
                    voters[msg.sender].groups[i] = voters[msg.sender].groups[i+1];
                    unchecked {
                        ++i;
                    }
                }
            voters[msg.sender].groups.pop();
            emit PermissionToVoteRemoved(_group);

    }
    
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

    function checkAllRights () public view returns (uint[] memory groups) {
        return  voters[msg.sender].groups; 
    }

}