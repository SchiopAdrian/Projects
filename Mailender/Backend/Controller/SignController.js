const {User} = require('../Models/SequlizerModel')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken');
require("dotenv").config;

const sign_in = async(req, res) =>{
    try{
        const {password, email} = req.body;
        const user = await User.findOne({
            where:{
                email:email,
            }
        }) 
        if(!user){
            return res.status(404).send('User not found');

        }
        const passwordValid = await bcrypt.compare(password, user.password)
        if(!passwordValid){
            return res.status(402).send('Incorrect email or password');
        }

        const token = jwt.sign({id:user.id},process.env.SECRET_TOKEN_KEY, {expiresIn:"1d"});
        res.setHeader('Authorization', `Bearer ${token}`);

        res.send({
            username:user.username,
            email:user.email,
            idUser:user.id,
        })
    }catch(e){
        console.log(e);
        return res.status(500).send('Unexpected error at login')
    }
}

const sign_up = async(req,res) =>{
    try{
        
        const {id,username,password, email} = req.body;
        const userExists = await User.findOne({
            where:{
                id:id,
            }
        });
        if(userExists){
            return res.status(500).send('Email is already associated with an account');
        }
        await User.create({
            id:id,
            username:username,
            password: await bcrypt.hash(password,15),
            email:email
        });
        
        return res.status(200).send('Registration successful')
    }catch(err){
        console.log(err);
        res.status(500).send('Unexpected error in registering user');
    }
}

const authenticate = (req, res, next) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        jwt.verify(token,process.env.SECRET_TOKEN_KEY, (err, decoded) => {
            if (err) {
                if (err.name === 'TokenExpiredError') {
                    
                    return res.status(401).send('Token has expired');
                }
                
                return res.status(401).send('Invalid token');
            }

            
            req.user = decoded;
            next();
            
        });
    } catch (err) {
        console.log(err);
        return res.status(500).send('Unexpected error during authentication');
    }
};
module.exports = {sign_in,sign_up,authenticate};