const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractDelegationsABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0x0f021dba3e86994176da8abb497e5a6380439147';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

async function delegate(groupId, reciever) {

    const tx = await contract.delegate(groupId, reciever);

    const txReceipt = await tx.wait();

    if (txReceipt.status === 1) {
        // console.log('Transaction successful');
        // console.log (txReceipt);
        const logs = txReceipt.logs;
        console.log(logs);

    //     const parsedLogs = logs.map(log => contract.interface.parseLog(log));

    //     const pollCreatedEvent = parsedLogs.find(log => log.name === 'PollCreated');

    //     if (pollCreatedEvent) {
    //         const pollId = pollCreatedEvent.args.pollId;
    //         const pollTitle = pollCreatedEvent.args.title;

    //         console.log('PollCreated event emitted');
    //         console.log('Poll Id', pollId.toString());
    //         console.log('Poll Title', pollTitle);
    //     } else {
    //         console.log('PollCreated event not found in the transaction logs');
    //     }
    // } else {
    //     console.error('Transaction failed');
    //     console.log(txReceipt);
    }
}
async function becomeDelegate(groupId){
    const tx = await contract.becomeDelegate(groupId);

    const txReceipt = await tx.wait();

    if (txReceipt.status === 1) {
        // console.log('Transaction successful');
        // console.log (txReceipt);
        const logs = txReceipt.logs;
        console.log(logs);
    }
}
becomeDelegate(1);
delegate(1, "0x18d1161FaBAC4891f597386f0c9B932E3fD3A1FD");