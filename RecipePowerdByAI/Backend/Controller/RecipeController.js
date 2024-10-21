const {v4:uuidv4} = require('uuid');
const {Recipes} = require('../model/ModelSequalizer');
const { Json } = require('sequelize/lib/utils');



const getAllFavoriteRecipes = async(req,res) =>{
    try{
        const recipes = await Recipes.findAll();
        const finalRecipies = recipes.map(recipe =>{
            return{
                id:recipe.id,
                name:recipe.name,
                ingredients:JSON.parse(recipe.ingredients),
                instructions:JSON.parse(recipe.instructions),
                preparationTime:recipe.preparationTime
            }
        })
        if(!recipes){
            return res.status(404).send('No recipies exist');
        }
        return res.status(200).json(recipes);
    }catch(error){
        console.error('Unexpected error at retreaving favorite recipes');
        return res.status(400).send({error, message:'Unexpected error at retreaving favorite recipes'})
    }
}

const createFavoriteRecipe = async(req, res) =>{
    try{
       
        console.log(req.body);
        const newRecipe = {
            id:req.body.id,
            name:req.body.name,
            ingredients: JSON.stringify(req.body.ingredients),
            instructions: JSON.stringify(req.body.instructions),
            preparationTime:req.body.preparationTime,
        }
        
        const recipe = await Recipes.create(newRecipe);
        
        if(!recipe){
            return res.status(400).send('Recipe was not created');
        }
        return res.status(200).json({recipe:recipe, message:'Recipe was added succesfully'});
    }catch(error){
        console.log(error);
        return res.status(400).send({error:error, message:'Unexpected error at creating a new favorite recipe'});
    }
}

const deleteFavoriteRecipe = async(req,res) =>{
    
    try{
        const id = req.params.id;

        const result = await Recipes.findByPk(id);

        if(!result){
            return res.status(404).send({message: `Recipe with ${id} not found`})
        }
        await result.destroy();
        res.status(200).send({message:'Recipe deleted from favorites list'})
    }catch(error){
        console.log(error)
        res.status(400).send({error, message:'Unexpected error at deleting recipe'})
    }
}

module.exports = {getAllFavoriteRecipes, createFavoriteRecipe,deleteFavoriteRecipe}