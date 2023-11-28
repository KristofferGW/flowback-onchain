const { ethers } = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractVoteABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0xca1a30490c83133c2b413c3d94ed53b6d360a04d';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const giveRightToVote = async(group)=> {

    // const pollCreatedEvent = parsedLogs.find(log => log.name === 'PollCreated');
    const tx = await contract.giveRightToVote(group);
    console.log(tx);

    //--------------------------------------------------------------
    // const txReceipt = await tx.wait();
    // console.log(txReceipt);
    // if (txReceipt.status === 1) {
    //     console.log('Transaction successful');

    //     const logs = txReceipt.logs;
    //     console.log(logs);
    //     const parsedLogs = logs.map(log => contract.interface.parseLog(log));

    //     const PermissionGivenToVote = parsedLogs.find(log => log.name === 'PermissionGivenToVote');
    //     console.log(PermissionGivenToVote)

    //     // if (pollCreatedEvent) {
    //     //     const pollId = pollCreatedEvent.args.pollId;
    //     //     const pollTitle = pollCreatedEvent.args.title;

    //     //     console.log('PollCreated event emitted');
    //     //     console.log('Poll Id', pollId.toString());
    //     //     console.log('Poll Title', pollTitle);
    //     // } else {
    //     //     console.log('PollCreated event not found in the transaction logs');
    //     // }
    // }
    //-------------------------------------------------------------------
}
const removeRightToVote = async (group) => {
    const tx = await contract.removeRightToVote(group);
    //console.log(tx);
}
const checkAllRights = async () => {
    const tx = await contract.checkAllRights();
    tx.map(group => {
        if(!parseInt(group._hex)){
            console.log("No groups found")
        }else{
            console.log(parseInt(group._hex)) 
    
        }})
        
}
const checkRightsInGroup = async (group) => {
    const tx = await contract.checkRightsInGroup(group);
    console.log(tx);
}


//giveRightToVote(1);
//removeRightToVote(1);
checkAllRights();

//checkRightsInGroup(4);