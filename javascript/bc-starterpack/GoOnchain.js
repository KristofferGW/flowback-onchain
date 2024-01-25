const newWallet = require('./newWallet');
const giveRightToVote = require('../vote/VoteBlockchain')

const GoOnchain = async (user )=>{
    const wallet = newWallet();
    giveRightToVote(user.groups); // get users groups somehow
    return wallet;
}

module.exports= GoOnchain;