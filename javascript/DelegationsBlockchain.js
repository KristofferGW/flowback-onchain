const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractDelegationsABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0x0f021dba3e86994176da8abb497e5a6380439147';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);