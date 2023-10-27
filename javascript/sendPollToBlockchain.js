const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);

const contractAddress = '0x7386bDA1604Fd197645801216C460f6c85e4615E';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

async function sendPollToBlockchain(title, tag, group, pollStartDate, proposalEndDate, votingStartDate, delegateEndDate, endDate) {

    const tx = await contract.createPoll(title, tag, group, pollStartDate, proposalEndDate, votingStartDate, delegateEndDate, endDate);

    const txReceipt = await tx.wait();

    if (txReceipt.status === 1) {
        console.log('Transaction successful');

        const logs = txReceipt.logs;

        const parsedLogs = logs.map(log => contract.interface.parseLog(log));

        const pollCreatedEvent = parsedLogs.find(log => log.name === 'PollCreated');

        if (pollCreatedEvent) {
            const pollId = pollCreatedEvent.args.pollId;
            const pollTitle = pollCreatedEvent.args.title;

            console.log('PollCreated event emitted');
            console.log('Poll Id', pollId.toString());
            console.log('Poll Title', pollTitle);
        } else {
            console.log('PollCreated event not found in the transaction logs');
        }
    } else {
        console.error('Transaction failed');
        console.log(txReceipt);
    }
}

sendPollToBlockchain("What should we have for dinner?", "Food", 1, 2, 3, 4, 5, 6);