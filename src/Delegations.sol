// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {RightToVote} from './RightToVote.sol';

/**
 * @title Delegations
 * @dev A contract that manages delegations for different groups.
 * @author @EllenLng, @KristofferGW
*/

contract Delegations is RightToVote {

    //Mapping over who is delegate in which group
    mapping(uint => GroupDelegate[]) public groupDelegates;
    
    //Mapping that keeps track of the number of delegates corresponding to groupId
    mapping(uint => uint) internal groupDelegateCount;
    
    // Mapping over which groups users have delegated in by address
    mapping(address => GroupDelegation[]) internal groupDelegationsByUser;

    // A struct that represents a delegate
    struct GroupDelegate {
        address delegate; // The address of the delegate.
        uint groupId; // The group ID of the group the delegate is a delegate in.
        uint delegatedVotes; // The number of delegated votes the delegate has.
        address[] delegationsFrom; // An array of addresses that have delegated to the delegate.
        uint groupDelegateId; // The delegate ID of the delegate.
    }

    struct GroupDelegation {
        uint groupId;
        uint timeOfDelegation;
    }

    // Event triggered when a new delegate is created.
    event NewDelegate(address indexed delegate, uint indexed groupId, uint delegatedVotes, address[] delegationsFrom, uint groupDelegateId);
    
    // Event triggered when a new delegation is created.
    event NewDelegation(address indexed from, address indexed to, uint indexed groupId, uint delegatedVotes, address[] delegationsFrom);

    // Event triggered when a delegate resigns.
    event DelegateResignation(address indexed delegate, uint indexed groupId);
    
   
    function _requireAddressIsDelegate(uint _groupId, address _potentialDelegate) private view {
        require(addressIsDelegate(_groupId, _potentialDelegate), "The address is not a delegate in the specified group");
    }

    modifier requireAddressIsDelegate(uint _groupId, address _potentialDelegate){
        _requireAddressIsDelegate(_groupId, _potentialDelegate);
        _;
    }
    /**
     * @dev Allows a user to become a delegate in a specific group.
     * @param _groupId The group ID of the group the delegate is a delegate in.
    */
    function becomeDelegate(uint _groupId) public {
        require(!addressIsDelegate(_groupId, msg.sender), "You are already a delegate in specific group");
        require(isUserMemberOfGroup(_groupId), "You need to be a member of the group to become a delegate");
        groupDelegateCount[_groupId]++;

        GroupDelegate memory newGroupDelegate = GroupDelegate({
            delegate: msg.sender,
            groupId: _groupId,
            delegatedVotes: 0,
            delegationsFrom: new address[](0),
            groupDelegateId: groupDelegateCount[_groupId]
        });

        groupDelegates[_groupId].push(newGroupDelegate);

        emit NewDelegate(newGroupDelegate.delegate, newGroupDelegate.groupId, newGroupDelegate.delegatedVotes, newGroupDelegate.delegationsFrom, newGroupDelegate.groupDelegateId);
    }

    /**
     * @dev Allows a user to delegate their vote to a delegate in a specific group.
     * @param _groupId The group ID of the group the delegate is a delegate in.
     * @param _delegateTo The address of the delegate to delegate to.
    */
    function delegate(uint _groupId, address _delegateTo) public requireAddressIsDelegate(_groupId, _delegateTo) {
        require(isUserMemberOfGroup(_groupId), "You can only delegate in groups you are a member of.");
        require(!hasDelegatedInGroup(_groupId), "You have an active delegation in this group.");
        require(_delegateTo != msg.sender, "You can not delegate to yourself");

        // add the group to the user's groupDelegationsByUser array
        GroupDelegation memory newGroupDelegation = GroupDelegation({
            groupId: _groupId,
            timeOfDelegation: block.timestamp
        });

        groupDelegationsByUser[msg.sender].push(newGroupDelegation);

        // increase the delegates delegatedVotes
        uint delegatedVotes;
        address[] memory delegationsFrom;
        uint arrayLength = groupDelegates[_groupId].length;
        for (uint i; i < arrayLength;) {
            if (groupDelegates[_groupId][i].delegate == _delegateTo) {
                groupDelegates[_groupId][i].delegatedVotes++;
                groupDelegates[_groupId][i].delegationsFrom.push(msg.sender);
                delegatedVotes = groupDelegates[_groupId][i].delegatedVotes;
                delegationsFrom = groupDelegates[_groupId][i].delegationsFrom;
            }

            unchecked {
                ++i;
            }
        }

        emit NewDelegation(msg.sender, _delegateTo, _groupId, delegatedVotes, delegationsFrom);
    }

    /**
     * @dev Allows a user to remove a delegation in a specific group.
     * @param _delegate The address of the delegate to remove the delegation from.
     * @param _groupId The group ID of the group the delegate is a delegate in.
    */
    function removeDelegation(address _delegate, uint _groupId) public {

        // check that the user has delegated to the specified delegate in the specified group
        require(hasDelegatedToDelegateInGroup(_groupId, _delegate), "You have not delegated to the specified delegate in this group");

        // decrease the number of delegated votes from the delegate
        // remove the user from the delegates delegationsFrom array
        uint delegatedVotes;
        uint arrayLength = groupDelegates[_groupId].length;
        for (uint i; i < arrayLength;) {
            if (groupDelegates[_groupId][i].delegate == _delegate) {
                groupDelegates[_groupId][i].delegatedVotes--;
                delegatedVotes = groupDelegates[_groupId][i].delegatedVotes;
                for (uint k; k < groupDelegates[_groupId][i].delegationsFrom.length;) {
                    if (groupDelegates[_groupId][i].delegationsFrom[k] == msg.sender) {
                        delete groupDelegates[_groupId][i].delegationsFrom[k];
                    }

                    unchecked {
                        ++k;
                    }
                }
            }

            unchecked {
                ++i;
            }
        }
        
        // remove the group from the user's groupDelegationsByUser array
        arrayLength = groupDelegationsByUser[msg.sender].length;
        for (uint i; i < arrayLength;) {
            if (groupDelegationsByUser[msg.sender][i].groupId == _groupId) {
                delete groupDelegationsByUser[msg.sender][i];
            }

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @dev Allows a user to resign as a delegate in a specific group.
     * @param _groupId The group ID of the group the delegate is a delegate in.
    */
    function resignAsDelegate(uint _groupId) public requireAddressIsDelegate(_groupId, msg.sender){
        address[] memory affectedUsers;

        // remove groupDelegationsByUsers for affected users
        uint arrayLength = groupDelegates[_groupId].length;
        for (uint i; i < arrayLength;) {
            if (groupDelegates[_groupId][i].delegate == msg.sender) {
                affectedUsers = groupDelegates[_groupId][i].delegationsFrom;
                delete groupDelegates[_groupId][i];
            }

            unchecked {
                ++i;
            }
        }

        for (uint i; i < affectedUsers.length; i++) {
            arrayLength = groupDelegationsByUser[affectedUsers[i]].length;
            for (uint k; k < arrayLength;) {
                if (groupDelegationsByUser[affectedUsers[i]][k].groupId == _groupId) {
                    delete groupDelegationsByUser[affectedUsers[i]][k];
                }

                unchecked {
                    ++k;
                }
            }
        }
        emit DelegateResignation(msg.sender, _groupId);
    }

    /**
     * @dev Checks if a user is delegate in a specific group.
     * @param _groupId The group ID of the group to check.
     * @return isDelegate Returns true if the user has delegated in the group, false otherwise.
    */
    function addressIsDelegate(uint _groupId, address _potentialDelegate) view private returns(bool isDelegate) {
        uint arrayLength = groupDelegates[_groupId].length;
        for (uint i; i < arrayLength;) {
            if (groupDelegates[_groupId][i].delegate == _potentialDelegate) {
                return true;
            }

            unchecked {
                ++i;
            }
        }
        return false;
    }

    /**
     * @dev Checks if a user has delegated in a specific group.
     * @param _groupId The group ID of the group to check.
     * @return hasDelegated Returns true if the user has delegated in the group, false otherwise.
    */
    function hasDelegatedInGroup(uint _groupId) public view returns (bool) {
        for (uint i = 0; i < groupDelegationsByUser[msg.sender].length;) {
            if (groupDelegationsByUser[msg.sender][i].groupId == _groupId) {
                return true;
            }

            unchecked {
                ++i;
            }
        }
        
        return false;
    }

    /**
     * @dev Checks if a user has delegated to a specific delegate in a specific group.
     * @param _groupId The group ID of the group to check.
     * @param _delegate The address of the delegate to check.
     * @return hasDelegated Returns true if the user has delegated to the delegate in the group, false otherwise.
    */
    function hasDelegatedToDelegateInGroup(uint _groupId, address _delegate) public view returns (bool) {
        uint arrayLength = groupDelegates[_groupId].length;
        for (uint i; i < arrayLength;) {
            if (groupDelegates[_groupId][i].delegate == _delegate) {
                arrayLength = groupDelegates[_groupId][i].delegationsFrom.length;
                for (uint k; k < arrayLength;) {
                    if (groupDelegates[_groupId][i].delegationsFrom[k] == msg.sender) {
                        return true;
                    }

                    unchecked {
                        ++k;
                    }
                }
            }

            unchecked {
                ++i;
            }
        }
        return false;
    }
}