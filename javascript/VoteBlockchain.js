const { ethers } = require('ethers');
require('dotenv').config({path: '../.env'});
const contractABI = require('./contractVoteABI.json');

const provider = new ethers.providers.InfuraProvider('sepolia', process.env.INFURA_API_KEY);
const wallet = new ethers.Wallet(process.env.SIGNER_PRIVATE_KEY, provider);


const contractAddress = '0xca1a30490c83133c2b413c3d94ed53b6d360a04d';

const contract = new ethers.Contract(contractAddress, contractABI, wallet);

const giveRightToVote = async(group)=> {

    // const pollCreatedEvent = parsedLogs.find(log => log.name === 'PollCreated');
    try {
        const tx = await contract.giveRightToVote(group);
        const txReceipt = await tx.wait();
        if (txReceipt.status === 1) {
            console.log('Transaction successful');
    
            const logs = txReceipt.logs;
    
            const parsedLogs = logs.map(log => contract.interface.parseLog(log));
    
            const permissionGivenEvent = parsedLogs.find(log => log.name === 'PermissionGivenToVote');
            if (permissionGivenEvent) {
                console.log(permissionGivenEvent.args)
                const group = parseInt(permissionGivenEvent.args._group)
                console.log("You now have the right to vote in group:", group)
                //const pollTitle = permissionGivenEvent.args.title;
            }
        }
    } catch (error) {
        console.log(error.error.reason)
    }
        
}

const removeRightToVote = async (group) => {
    const tx = await contract.removeRightToVote(group);
    //console.log(tx);
}

const checkAllRights = async () => {
    const tx = await contract.checkAllRights();
    if(tx==""){
        console.log("No groups found")
    }else{
        tx.map(group => {
            console.log(parseInt(group._hex));
        })
    }   
}

const checkRightsInGroup = async (group) => {
    const tx = await contract.checkRightsInGroup(group);
    console.log(tx);
}


//giveRightToVote(6); //- DONE
//removeRightToVote(1);
checkAllRights(); //- DONE

//checkRightsInGroup(4);
