// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './RightToVote.sol';

contract Delegations is RightToVote {
    //Mappping over who is delegate in which group
    mapping(uint => GroupDelegate[]) public groupDelegates;
    //Mapping that keeps track of the number of delegates corresponding to groupId
    mapping(uint => uint) internal groupDelegateCount;
    // Mapping over which groups users have delegated in by address
    mapping(address => uint[]) internal groupDelegationsByUser;

    struct GroupDelegate {
        address delegate;
        uint groupId;
        uint delegatedVotes;
        address[] delegationsFrom;
        uint groupDelegateId;
    }

    event NewDelegate(address delegate, uint groupId, uint delegatedVotes, address[] delegationsFrom, uint groupDelegateId);

    function becomeDelegate(uint _groupId) public {
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

    event NewDelegation(address from, address to, uint groupId, uint delegatedVotes, address[] delegationsFrom);

    function delegate(uint _groupId, address _delegateTo) public {
        require(addressIsDelegate(_groupId, _delegateTo), "The address is not a delegate in the specified group");
        require(delegaterIsInGroup(_groupId), "You can only delegate in groups you are a member of.");
        require(!hasDelegatedInGroup(_groupId), "You have an active delegation in this group.");
        require(_delegateTo != msg.sender, "You can not delegate to yourself");
        // add active delegation to groupDelegationsByUser
        groupDelegationsByUser[msg.sender].push(_groupId);
        // increase the delegates delegatedVotes
        uint delegatedVotes;
        address[] memory delegationsFrom;
        for (uint i; i < groupDelegates[_groupId].length; i++) {
            if (groupDelegates[_groupId][i].delegate == _delegateTo) {
                groupDelegates[_groupId][i].delegatedVotes++;
                groupDelegates[_groupId][i].delegationsFrom.push(msg.sender);
                delegatedVotes = groupDelegates[_groupId][i].delegatedVotes;
                delegationsFrom = groupDelegates[_groupId][i].delegationsFrom;
            }
        }

        emit NewDelegation(msg.sender, _delegateTo, _groupId, delegatedVotes, delegationsFrom);
    }

    event DelegationRemoved(address from, address by, uint groupId, uint delegatedVotes);

    function removeDelegation(address _delegate, uint _groupId) public {
        // check that the user has delegated to the specified delegate in the specefied group
        require(hasDelegatedToDelegateInGroup(_groupId, _delegate), "You have not delegated to the specified delegate in this group");
        // decrease the number of delegated votes from the delegate
        // remove the user from the delegates delegationsFrom array
        uint delegatedVotes;
        for (uint i; i < groupDelegates[_groupId].length; i++) {
            if (groupDelegates[_groupId][i].delegate == _delegate) {
                groupDelegates[_groupId][i].delegatedVotes--;
                delegatedVotes = groupDelegates[_groupId][i].delegatedVotes;
                for (uint k; k < groupDelegates[_groupId][i].delegationsFrom.length; k++) {
                    if (groupDelegates[_groupId][i].delegationsFrom[k] == msg.sender) {
                        delete groupDelegates[_groupId][i].delegationsFrom[k];
                    }
                }
            }
        }
        // remove the group from the users groupDelegationsByUser array
        for (uint i; i < groupDelegationsByUser[msg.sender].length; i++) {
            if (groupDelegationsByUser[msg.sender][i] == _groupId) {
                delete groupDelegationsByUser[msg.sender][i];
            }
        }
        emit DelegationRemoved(_delegate, msg.sender, _groupId, delegatedVotes);
    }

    event DelegateResignation(address delegate, uint groupId);

    function resignAsDelegate(uint _groupId) public {
        address[] memory affectedUsers;
        // remove groupDelegationsByUsers for affected users
        for (uint i; i < groupDelegates[_groupId].length; i++) {
            if (groupDelegates[_groupId][i].delegate == msg.sender) {
                affectedUsers = groupDelegates[_groupId][i].delegationsFrom;
                delete groupDelegates[_groupId][i];
            }
        }

        for (uint i; i < affectedUsers.length; i++) {
            for (uint k; k < groupDelegationsByUser[affectedUsers[i]].length; k++) {
                if (groupDelegationsByUser[affectedUsers[i]][k] == _groupId) {
                    delete groupDelegationsByUser[affectedUsers[i]][k];
                }
            }
        }
        emit DelegateResignation(msg.sender, _groupId);
    }

    function addressIsDelegate(uint _groupId, address _potentialDelegate) view private returns(bool isDelegate) {
        for (uint i; i < groupDelegates[_groupId].length; i++) {
            if (groupDelegates[_groupId][i].delegate == _potentialDelegate) {
                return true;
            }
        }
        return false;
    }

    function delegaterIsInGroup(uint _groupId) view private returns(bool isInGroup) {
        for (uint i; i < voters[msg.sender].groups.length; i++) {
            if (voters[msg.sender].groups[i] == _groupId) {
                return true;
            }
        }
        return false;
    }

    function hasDelegatedInGroup(uint _groupId) public view returns (bool) {
        uint[] memory userDelegatedGroups = groupDelegationsByUser[msg.sender];
        for (uint i; i < userDelegatedGroups.length; i++) {
            if (userDelegatedGroups[i] == _groupId) {
                return true;
            }
        }
        return false;
    }

    function hasDelegatedToDelegateInGroup(uint _groupId, address _delegate) public view returns (bool) {
        for (uint i; i < groupDelegates[_groupId].length; i++) {
            if (groupDelegates[_groupId][i].delegate == _delegate) {
                for (uint k; k < groupDelegates[_groupId][i].delegationsFrom.length; k++) {
                    if (groupDelegates[_groupId][i].delegationsFrom[k] == msg.sender) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

}