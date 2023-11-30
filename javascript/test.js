const newWallet = require('./newWallet');
const getProposals = require('./pollsBlockchain')

const wallet = newWallet();
const proposals = getProposals(1);
console.log(proposals);

console.log('public key:', wallet.publicKey);
console.log('private key:', wallet.privateKey);