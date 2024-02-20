const { ethers } = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0xA58c7359fFd9DCC380a95C8092487F28AC5039DF';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const giveRightToVote = async(group)=> {

    try {
        const tx = await contract.giveRightToVote(group);
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
        console.log(error.error.reason)
    }
        
}

const removeRightToVote = async (group) => {

    try {
        const tx = await contract.removeRightToVote(group);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            const logs = txReceipt.logs;
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const permissionGivenEvent = parsedLogs.find(log => log.name === 'PermissionToVoteRemoved');
            if (permissionGivenEvent) {
                const group = parseInt(permissionGivenEvent.args._group)
                console.log("Successfully removed right to vote in group:", group)
            }
        }
    } catch (error) {
        console.log(error.error.reason)
    }
}

const checkAllRights = async () => {
    const tx = await contract.checkAllRights();
    if(tx==""){
        console.log("No groups found")
    }else{
        tx.map(group => {
            console.log("You have rights in following groups:", parseInt(group._hex));
        })
    }   
}

const checkRightsInGroup = async (group) => {
    const tx = await contract.checkRightsInGroup(group);
    if(tx)
        console.log("You have right to vote in group", group)
    else
        console.log("You do not have rights to vote in group", group)
}
//giveRightToVote(2); 
//removeRightToVote(2); 
//checkAllRights(); 
checkRightsInGroup(2);
module.exports = giveRightToVote, removeRightToVote, checkAllRights, checkRightsInGroup;

