// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './RightToVote.sol';

contract Delegations is RightToVote {
    //Mappping over who is delegate in which group
    mapping(uint => GroupDelegate[]) public groupDelegates;
    //Mapping that keeps track of the number of delegates corresponding to groupId
    mapping(uint => uint) internal groupDelegateCount;

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

    event ResignationAsDelegate(address resigner, uint groupId);

    // resignAsDelegate function needs testing
    function resignAsDelegate(uint _groupId) public {
        // change hasDelegated to false for everyone who has delegated to the user who is resigning
        // then delete the delegate from groupDelegates
        address[] memory hasDelegated;

        for (uint i; i < groupDelegates[_groupId].length; i++) {
            if (groupDelegates[_groupId][i].delegate == msg.sender) {
                for (uint k; k < groupDelegates[_groupId][i].delegationsFrom.length; k++) {
                    hasDelegated[k] = groupDelegates[_groupId][i].delegationsFrom[k];
                }
                delete groupDelegates[_groupId][i];
            }
        }

        emit ResignationAsDelegate(msg.sender, _groupId);
    }

    // function delegate
    // will have to add voting power to standard users with the value 1, which can be substracted from the one that delegates to prevent double voting

    // function removeDelegation
}

