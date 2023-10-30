const CryptoJS = require('crypto-js');
const generateSecretKey = require('./generateSecretKey');

function encryptPrivateKey(privateKeyToEncrypt) {
    const privateKey = privateKeyToEncrypt;
    const secretKey = generateSecretKey();

    const encryptedPrivateKey = CryptoJS.AES.encrypt(privateKey, secretKey).toString();

    console.log('encrypted key',encryptedPrivateKey);
}

encryptPrivateKey('0xewoirdkfpw8fd');


