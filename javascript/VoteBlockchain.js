const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractVoteABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0xcff51468cece75b64dd37e047ca6db70232939f1';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const giveRightToVote = async(group)=> {

    // const pollCreatedEvent = parsedLogs.find(log => log.name === 'PollCreated');
    const tx = await contract.giveRightToVote(group);
    console.log(tx);
    const txReceipt = await tx.wait();
    console.log(txReceipt);
}
const removeRightToVote = async (group) => {
    const tx = await contract.removeRightToVote(group);
    console.log(tx);
}
const checkAllRights = async () => {
    const tx = await contract.checkAllRights();
    console.log(tx);
}
const checkRightsInGroup = async (group) => {
    const tx = await contract.checkRightsInGroup(group);
    console.log(tx);
}


//giveRightToVote(2);
// checkAllRights();
removeRightToVote(1);
//checkRightsInGroup(1);