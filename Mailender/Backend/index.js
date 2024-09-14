require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser')
const cron = require('node-cron');
const nodemailer = require('nodemailer');
const {decypt} = require('./utils/encryption.js');
const {router} = require('./Router/router.js');
const {Emails, sequelize} = require('./Models/SequlizerModel.js');
const { Sequelize } = require('sequelize');


const app = express();
app.use(bodyParser.urlencoded({extended:true}))
app.use(bodyParser.json());
app.use(router);


cron.schedule('* * * * *', async() =>{
    const currentUTC = new Date();
    const offset = 180;
    
    const emails = await Emails.findAll({where: {send:false, dateAndTimeSend: {[Sequelize.Op.lte]:currentUTC}}});
    
    emails.forEach(async (email) =>{
        const decryptedPassword = email.userPassword;
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth:{
                user:email.userEmail,
                pass: decryptedPassword
            }
        });

        const mailOptions = {
            from: email.userEmail,
            to: email.to,
            cc:email.cc,
            bcc: email.bcc,
            subject: email.subject,
            text: email.content,
        };

        transporter.sendMail(mailOptions, async (error, info) =>{
            if(error){
                console.log(error);
            }else{
                console.log('Email send: ' + info.response);
                email.send = true;
                await email.save();
            }
        });
    });
});

cron.schedule('* * * * *', async ()=>{
    const currentUTC = new Date();
    const offset = 180;
    
    const emails = await Emails.findAll({where:{send:1, responseReceived:0, reminderSend:0, dateAndTimeReminder: {[Sequelize.Op.lte]:currentUTC}}});
    
    emails.forEach(async (email) => {
        const decryptedPassword = email.userPassword;
        const transporter = nodemailer.createTransport({
            service:'gmail',
            auth: {
                user: email.userEmail,
                pass: decryptedPassword,
            },
        });
        const mailOptions = {
            from: email.userEmail,
            to: email.to,
            cc: email.cc,
            bcc: email.bcc,
            subject: `Reminder: ${email.subject}`,
            text: `This is a reminder about: \n${email.content}`,
        };
        
        transporter.sendMail(mailOptions, async (error, info) => {
            if (error) {
              console.log(error);
            } else {
              console.log('Reminder sent: ' + info.response);
              email.destroy();
            }
        });
        
    });
});




const port = process.env.PORT || 3000;
app.listen(port, (error)=>{
    if(!error)
        console.log("Server running at port: ", port);
    else
        console.error("Error ocuured: ", error);
})



