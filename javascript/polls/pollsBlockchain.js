
const { ethers } = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('../contractPollsABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0x9ae98aa7c16e87f559b81c5d4ae0d44a5a46e740';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);


const createPoll = async(title, tag, group, pollStartDate, proposalEndDate, votingStartDate, delegateEndDate, endDate)=> {
    try {
        const tx = await contract.createPoll(title, tag, group, pollStartDate, proposalEndDate, votingStartDate, delegateEndDate, endDate);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            const logs = txReceipt.logs;
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const PollCreatedEvent = parsedLogs.find(log => log.name === 'PollCreated');
            if (PollCreatedEvent) {
                const pollId = parseInt(PollCreatedEvent.args.pollId);
                const title = PollCreatedEvent.args.title;
                console.log(`Poll created with title ${title} and id ${pollId}`);
            }
        }
        
    } catch (error) {
        console.log(error)
    }
}

const createProposal = async(pollId, description)=> {
    try {
        const tx = await contract.addProposal(pollId, description);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            const logs = txReceipt.logs;
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const ProposalAddedEvent = parsedLogs.find(log => log.name === 'ProposalAdded');
            if (ProposalAddedEvent) {
                const pollId = parseInt(ProposalAddedEvent.args.pollId);
                const description = ProposalAddedEvent.args.description;
                const proposalId = parseInt(ProposalAddedEvent.args.proposalId);
                console.log(`Proposal created on poll id ${pollId}, description: ${description} id: ${proposalId}`);
            }
        }
        
    } catch (error) {
        console.log(error)
    }
}
const getProposals = async(pollId)=> {

    try {
        const tx = await contract.getProposals(pollId);
        tx.map(info => console.log(parseInt(info.proposalId), info.description));
        return tx.args;
        
    } catch (error) {
        console.log(error)
    }
}

const getPollResults= async(pollId)=> {
    try {
        const tx = await contract.getProposals(pollId);
        console.log(tx);
    } catch (error) {
        console.log(error)
    }
}
const vote= async(pollId,proposalId)=> {
    try {
        const tx = await contract.vote(pollId,proposalId);
        console.log(tx);
    } catch (error) {
        console.log(error.error.reason);
    }
}
//createProposal(1,"proposal");
//createPoll("Poll", "poll", 1,1,1,1,1,1);
//getProposals(1);
//*****getPollResults(1);
//*****vote(1,1);


module.exports = createPoll, createProposal, getProposals;