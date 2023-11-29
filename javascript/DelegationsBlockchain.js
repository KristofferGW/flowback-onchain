const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractDelegationsABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0x0f021dba3e86994176da8abb497e5a6380439147';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

async function delegate(groupId, reciever) {

    const tx = await contract.delegate(groupId, reciever);

    const txReceipt = await tx.wait();

    if (txReceipt.status === 1) {
        // console.log('Transaction successful');
        // console.log (txReceipt.logs);
        

    }
}
async function becomeMemberOfGroup(groupId){
    const tx = await contract.giveRightToVote(groupId);
    

    const txReceipt = await tx.wait();
    console.log(txReceipt);
    
    if (txReceipt.status === 1) {
        console.log('Transaction successful');
        console.log(txReceipt);

    }
}
async function becomeDelegate(groupId){

    try {
        const tx = await contract.becomeDelegate(groupId);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
    
            const logs = txReceipt.logs;
    
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const NewDelegateEvent = parsedLogs.find(log => log.name === 'NewDelegate');
            if (NewDelegateEvent) {
                console.log(NewDelegateEvent.args)
                // const group = parseInt(NewDelegateEvent.args._group)
                // console.log("You now have the right to vote in group:", group)
            }
        }
    } catch (error) {
        console.log(error.error.reason)
    }
    
}


becomeMemberOfGroup(1)
//becomeDelegate(1);

//delegate(1,"adress");

