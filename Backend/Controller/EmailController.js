const {v4:uuidv4} = require('uuid');
const {Emails} = require('../Models/SequlizerModel');
const nodemailer = require('nodemailer');
const cron = require('node-cron');
const { encrypt } = require('../utils/encryption');
const createEmail = async(req,res) =>{
    try{
        
        console.log(req.idUser);
        send = false;
        reminderSend = false;
        responseReceived = false;

        
        const newEmail = {...req.body,send:send,reminderSend:reminderSend,responseReceived:responseReceived};
        
        const email = await Emails.create(newEmail);
        console.log(email);
        const username = req.username
        return res.status(200).json({email: email, message:`Email send added succesfully to user ${username}`});
        
    }catch(err){
        console.log(err);
        return res.status(500).send({err, message: 'Unexpected error while creating an Email'});
    }
}


const getAllEmails = async(req,res) =>{
    try{
        const userId = req.idUser;
        console.log(userId);
        const emails = await Emails.findAll({where: {UserId:userId}});
        if(!emails){
            return res.status(404).send('No emails assigned to the user');
        }
        return res.status(200).json(emails);
    }catch(err){
        console.error('Unexpected error at getting tasks');
        return res.status(500).send({err, message:"Unexpected error at getting emails"});
    }
}

const getOneEmail = async(req,res) =>{
    try{
        const id = req.params.id;
        const email = await Emails.findByPk(id);
        if(!email){
            return res.status(404).send(`Email with id ${id} not found`);
        }
        return res.status(200).send(email);
    }catch(err){
        return res.status(500).send({err,message:"Unexpected error at getting an email"});
    }
}

const deleteEmail = async(req,res) =>{
    try{
        const id = req.params.id;
        const email = await Emails.findByPk(id);
        if(!email){
            return res.status(404).send(`Email with id ${id} not found`);
        }
        await email.destroy();
        return res.status(200).send('Task deleted succesfully');

    }catch(err){
        return res.status(500).send({err,message:'Unexpected error at deleting an email'});
    }
}
const updateEmail = async(req,res) =>{
    try{
        const id = req.params.id;
        const updatedEmail = {...req.body};
        const email = await Emails.findByPk(id);
        console.log(email);
        if(!email){
            res.status(404).send({email:email, message: `Email with id ${id} not found`});
        }
        await email.update(updatedEmail);
        return res.status(200).send(email);
    }catch(err){
        res.status(400).send({err,message:'Unexpected error at update email'});
    }
}
module.exports={createEmail,getAllEmails,getOneEmail,deleteEmail,updateEmail};

