const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractVoteABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0xcff51468cece75b64dd37e047ca6db70232939f1';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const giveRightToVote = async(group)=> {

    const tx = await contract.giveRightToVote(group);
    console.log(tx);

}
giveRightToVote(1)