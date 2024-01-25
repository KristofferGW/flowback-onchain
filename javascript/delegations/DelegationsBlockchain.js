const {ethers} = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractDelegationsABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0x10bc596f432c182a7f4bbbd85febf33c23edb91e';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const delegate = async(groupId, reciever)=> { 

    try {
        const tx = await contract.delegate(groupId, reciever);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            console.log (txReceipt.logs);
        }
    } catch (error) {
        console.log(error);
    } 
}

const becomeDelegate = async(groupId)=> { 

    try {
        const tx = await contract.becomeDelegate(groupId);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            const logs = txReceipt.logs;
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
            const NewDelegateEvent = parsedLogs.find(log => log.name === 'NewDelegate');
            if (NewDelegateEvent) {
                const group = parseInt(NewDelegateEvent.args.groupId)
                console.log("You are now a delegate in group:", group)
            }
        }
    } catch (error) {
        console.log(error.error.reason)
    }
}

const resignAsDelegate = async(group)=> { 

    try {
        const tx = await contract.resignAsDelegate(group);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
            const logs = txReceipt.logs;
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const DelegateResignationEvent = parsedLogs.find(log => log.name === 'DelegateResignation');
            if (DelegateResignationEvent) {
                const group = parseInt(DelegateResignationEvent.args.groupId);
                console.log("You are no longer a delegate in group:", group);
            }
        }
    } catch (error) {
        console.log(error);
    } 
}




becomeDelegate(1);
//*delegate(1,"0x04cf74ef3c25718e11556c48e8c563cc8d3f4a692aa18ffcacda2f8fbbfcd27702f1b110c734bcd51e920eeec1747f8d98cd28246d27c47cf7d09a956d00f104a6");
//resignAsDelegate(1); 
