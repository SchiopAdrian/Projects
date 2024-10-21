const express = require('express');
const { getAllFavoriteRecipes, createFavoriteRecipe, deleteFavoriteRecipe } = require('../Controller/RecipeController');
const { getRecipes, getPremadeRecipes } = require('../Controller/OpenAIController');

const router = express.Router();

router.get('/favoriteRecipes', getAllFavoriteRecipes);
router.post('/favoriteRecipe', createFavoriteRecipe);
router.get('/recipes', getPremadeRecipes);
router.delete('/favoriteRecipe/:id', deleteFavoriteRecipe);
module.exports = {router}