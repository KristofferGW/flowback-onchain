const newWallet = require('./newWallet');

const wallet = newWallet();

console.log('public key:', wallet.publicKey);
console.log('private key:', wallet.privateKey);