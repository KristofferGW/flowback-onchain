// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegations {
    //Mapping över vilka som är delegates i vilken grupp
    mapping(uint => GroupDelegate[]) public groupDelegates;
    //Mapping över antal delegater via groupId
    mapping(uint => uint) internal groupDelegateCount;

    struct GroupDelegate {
        address delegate;
        uint groupId;
        uint delegatedVotes;
        address[] delegationsFrom;
        uint groupDelegateId;
    }

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
    }

    // function resignAsDelegate

    // function delegate

    // function removeDelegation

    // function showDelegationsToDelegate
}

