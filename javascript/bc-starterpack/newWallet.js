const { ethers } = require('ethers');

const newWallet = () => {

    const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);

    const userWallet = ethers.Wallet.createRandom();
    let wallet = new ethers.Wallet(userWallet.privateKey);

    let walletWithProvider = new ethers.Wallet(wallet.privateKey, provider);
    return walletWithProvider;
      
}
module.exports = newWallet;
