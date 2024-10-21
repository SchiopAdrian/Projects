const express = require('express');
const { router } = require('./router/router');
const bodyParser = require('body-parser');
require('dotenv').config();
const cors = require('cors');

const app = express();

const PORT = process.env.PORT || 3000;
app.use(cors());
app.use(bodyParser.urlencoded({extended:true}));
app.use(bodyParser.json());
app.use(router)


app.listen(PORT, (error)=>{
    if(!error){
        console.log("Server running at port:", PORT);
    }else{
        console.error("Error at starting the server: ", error)
    }
})
