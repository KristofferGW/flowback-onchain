const { ethers } = require('ethers');
require('dotenv').config({path: '../../.env'});
const contractABIa = require('../ABI/contractABI.json');
const createPoll = require('../polls/pollsBlockchain');
const createProposal = require('../polls/pollsBlockchain');
const contractABI = require('../ABI/contractABI.json');

const provider = new ethers.providers.InfuraProvider(process.env.ETHEREUM_NETWORK, process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0xf43205cD2E7Ab7416D73cCcFC30cD5d980c9A31a';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const createPrediction = async(pollId, proposalId, prediction)=> {
    try {
        const tx = await contract.createPrediction(pollId, proposalId, prediction);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            const logs = txReceipt.logs;
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const predictionCreatedEvent = parsedLogs.find(log => log.name === 'PredictionCreated');
            if (predictionCreatedEvent) {
                const predictionId = parseInt(predictionCreatedEvent.args.predictionId);
                const description = predictionCreatedEvent.args.prediction;
                console.log(`New prediction created, id: ${predictionId}, description: ${description}`);
            }
        }
    } catch (error) {
        console.log(error.error);
    }
    
}

const getPredictions = async(pollId,proposalId) =>{
    try {
        const tx = await contract.getPredictions(pollId, proposalId);
        tx.map(info => 
            console.log(`Proposal: ${parseInt(info.proposalId)}, Prediction: ${parseInt(info.predictionId)}, description: ${info.prediction}`));
    } catch (error) {
        console.log(error.error);
    }
}
const placePredictionBet = async(pollId, proposalId, predictionId, likelihood, bet)=> {
    try {
        const tx = await contract.placePredictionBet(pollId, proposalId, predictionId,likelihood, bet);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            const logs = txReceipt.logs;
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const PredictionBetCreatedEvent = parsedLogs.find(log => log.name === 'PredictionBetCreated');
            if (PredictionBetCreatedEvent) {
                const predictionId = parseInt(PredictionBetCreatedEvent.args.predictionId);
                const description = PredictionBetCreatedEvent.args.bet;
                const likelihood = PredictionBetCreatedEvent.args.likelihood;
                console.log(`New predictionbet placed on predictionid: ${predictionId}, bet: ${description}, likelihood: ${likelihood}`);
            }
        }
    } catch (error) {
        console.log(error.error.reason);
    }
    
}
const getPredictionBets = async(pollId, proposalId, predictionId)=> {
    try {
        const tx = await contract.getPredictionBets(pollId, proposalId, predictionId);
        tx.map(info => 
            console.log(`PredictionBet on proposal: ${parseInt(info.proposalId)} on predicitonBet: ${parseInt(info.predictionId)}, Bet: I am ${info.likelihood}% sure that the prediction will be: ${info.bet}`));
    } catch (error) {
        console.log(error.error.reason);
    }
    
}
//createPoll("Poll", "poll", 1, 1, 1, 1, 1, 1)
//createProposal(1,"proposal");
//createPrediction(1,1,"prediction");
//getPredictions(1,1);
//placePredictionBet(1,1,1,10,true);
//getPredictionBets(1,1,1);

module.exports = createPrediction, getPredictions, placePredictionBet, getPredictionBets;