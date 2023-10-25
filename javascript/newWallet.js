const { ethers } = require('ethers');

const newWallet = () => {

    //add provider (infura)
    //const provider = new ethers.providers.JsonRpcProvider('https://mainnet.infura.io/v3/MYKEYISHERE')
    let provider = new ethers.providers.getDefaultProvider();

    const userWallet = ethers.Wallet.createRandom();
    let wallet = new ethers.Wallet(userWallet.privateKey);

    let walletWithProvider = new ethers.Wallet(wallet.privateKey, provider);
    return walletWithProvider;
      
}
module.exports = newWallet;
