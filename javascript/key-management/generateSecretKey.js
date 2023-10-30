function generateSecretKey() {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const keyLength = 32;

    let secretKey = '';
    for (let i = 0; i < keyLength; i++) {
        const randomIndex = Math.floor(Math.random() * charset.length);
        secretKey += charset[randomIndex];
    }

    console.log('Secret key', secretKey);
    return secretKey;
}

module.exports = generateSecretKey;