const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);

const contractAddress = '0x7386bDA1604Fd197645801216C460f6c85e4615E';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

async function sendPollToBlockchain(title, tag, group, pollStartDate, proposalEndDate, votingStartDate, delegateEndDate, endDate) {

    const tx = await contract.createPoll(title, tag, group, pollStartDate, proposalEndDate, votingStartDate, delegateEndDate, endDate);

    await tx.wait();

    console.log('Transaction successful! Transaction hash:', tx.hash);
}

sendPollToBlockchain("What should we have for dinner?", "Food", 1, 2, 3, 4, 5, 6);