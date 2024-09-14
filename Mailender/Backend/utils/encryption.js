const crypto = require('crypto');
require('dotenv').config();

const ENCRIPTION_KEY = Buffer.from(process.env.ENCRIPTION_KEY, 'base64');
const IV = Buffer.from(process.env.IV, 'base64');

const encrypt = (text) =>{
    const cipher = crypto.createCipheriv('aes-256-ccm', ENCRIPTION_KEY, IV);
    let encrypted = cipher.update(text, 'utf-8', 'base64');
    encrypted += cipher.final('base64');
    return encrypted;
}

const decrypt = (encryptedText)=>{
    const decipher = crypto.createDecipheriv('aes-256-ccm', ENCRIPTION_KEY, IV);
    let decrypted = decipher.update(encryptedText, 'base64', 'utf-8');
    decrypted +=decipher.final('utf-8');
    return decrypted;
}

module.exports = {encrypt, decrypt};