const ethers = require('ethers');
require('dotenv').config({path: '../../.env'});
const contractABI = require('../ABI/contractABI.json');


const provider = new ethers.providers.InfuraProvider(process.env.ETHEREUM_NETWORK, process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0xf43205cD2E7Ab7416D73cCcFC30cD5d980c9A31a';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const becomeMemberOfGroup = async(group)=> {

    try {
        const tx = await contract.becomeMemberOfGroup(group);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
    
            const logs = txReceipt.logs;
    
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const permissionGivenEvent = parsedLogs.find(log => log.name === 'PermissionGivenToVote');
            if (permissionGivenEvent) {
                const group = parseInt(permissionGivenEvent.args._group)
                console.log("You now have the right to vote in group:", group)
            }
        }
    } catch (error) {
        console.log(error.error)
    }
        
}

const removeGroupMembership = async (group) => {

    try {
        const tx = await contract.removeGroupMembership(group);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            console.log("Successfully removed membership in group:", group);
        }
    } catch (error) {
        console.log(error.error)
    }
}

const getGroupsUserIsMemberIn = async () => {
    const tx = await contract.getGroupsUserIsMemberIn();
    if(tx==""){
        console.log("No groups found")
    }else{
        console.log("You are member in following groups:");
        tx.map(group => {
            console.log(parseInt(group._hex));
        })
        
    }   
}

const isUserMemberOfGroup = async (group) => {
    const tx = await contract.isUserMemberOfGroup(group);
    if(tx)
        console.log("You have right to vote in group", group);
    else
        console.log("You do not have rights to vote in group", group)
}
// getGroupsUserIsMemberIn();
// becomeMemberOfGroup(1)
// isUserMemberOfGroup(1);
// removeGroupMembership(1);



module.exports = getGroupsUserIsMemberIn, isUserMemberOfGroup, becomeMemberOfGroup, removeGroupMembership;

