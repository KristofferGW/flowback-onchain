const { ethers } = require('ethers');

const newWallet = () => {

    const userWallet = ethers.Wallet.createRandom();
    const response = {
        privateKey: userWallet.privateKey,
        address: userWallet.address,
    }
    console.log(response)
}
module.exports = newWallet;
