const {Sequelize, DataTypes} = require('sequelize');

require("dotenv").config();

const sequelize = new Sequelize(process.env.DB_NAME, 'root', process.env.DB_PASSWORD, {
    host:process.env.DB_HOST,
    dialect:'mysql',
    port:process.env.DB_PORT
})

sequelize.authenticate()
    .then(()=>{
        console.log('Connection succesful');
    }).catch(error =>{
        console.error('Unable to connect to database: ', error);
    });

    const Recipes = sequelize.define("Recipes",{
        id:{
            type:DataTypes.UUID,
            defaultValue:Sequelize.UUIDV4,
            allowNull:false,
            validate:{
                notEmpty:true
            },
            primaryKey:true
        },
        name:{
            type:DataTypes.STRING,
            allowNull: false,
        },
        instructions:{
            type:DataTypes.TEXT,
            allowNull:false,
        },
        ingredients:{
            type:DataTypes.TEXT,
            allowNull:false
        },
        preparationTime:{
            type:DataTypes.STRING,
            allowNull:false
        },
    
    })


sequelize.sync({force:false}) //set to true for 1st run of the program in order to create the table
module.exports = {Recipes};
    