const newWallet = require('./newWallet');
const giveRightToVote = require('../VoteBlockchain')

const GoOnchain = async (user )=>{
    const wallet = newWallet();
    giveRightToVote(user.groups); // get users groups somehow
    return wallet;
}

module.exports= GoOnchain;