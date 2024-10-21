import { useEffect, useState } from "react";

const { useParams, useNavigate } = require("react-router-dom");
const { useRecipeContext } = require("../contexts/recipeContext");

const DetailsPage = () => {
  const {
    recipes,
    getRecipeById,
    addToFavoriteRecipes,
    deleteFromFavoriteRecipies,
  } = useRecipeContext();
  const { id } = useParams();
  const navigate = useNavigate(); // Use useNavigate to programmatically navigate
  const recipe = getRecipeById(id);

  useEffect(() => {
    // If no recipe is found, redirect to the MainPage
    if (!recipe) {
      navigate("/"); // Redirect to the main page
    }
  }, [recipe, navigate]);

  if (!recipe) {
    return null;
  }

  const ingredients = recipe.ingredients;
  const instructions = recipe.instructions;

  const handleAddingFavorite = (id) => {
    const newFavorite = recipes.find((recipe) => recipe.id === id);
    addToFavoriteRecipes(newFavorite);
  };

  const handleDeletingFavorite = (id) => {
    deleteFromFavoriteRecipies(id);
  };

  if (!recipe) {
    return <div>Recipe not found.</div>;
  }

  return (
    <div className="flex flex-col lg:flex-row px-5 py-8 lg:px-80">
      <div className="sticky top-0 bg-white z-50 pt-3">
        <div className="flex-shrink-0 lg:w-[400px] lg:mr-16 lg:mb-0">
          <div>
            <img
              src="https://placehold.co/400"
              className="lg:w-[400px] lg:h-[400px] w-[200px] h-[200px] object-cover border-4 border-black"
            />
          </div>
        </div>

        {/* Sticky Section: Title and Button */}

        <div className="font-bold text-3xl mt-4">{recipe.name}</div>
        <div className="text-3xl mt-2">
          {!recipe.isFavorite ? (
            <button onClick={() => handleAddingFavorite(recipe.id)}>
              <i className="fa-regular fa-heart"></i>
            </button>
          ) : (
            <button onClick={() => handleDeletingFavorite(recipe.id)}>
              <i className="fa-solid fa-heart"></i>
            </button>
          )}
        </div>
      </div>

      {/* Ingredients and Instructions */}
      <div>
        <div className="lg:mt-0 mt-10">
          <h1 className="font-bold text-3xl">Ingredients</h1>
          <ul className="list-disc ml-6 mt-4">
            {ingredients.map((ingredient, index) => (
              <li key={index} className="mb-2 text-xl">
                {ingredient}
              </li>
            ))}
          </ul>
        </div>
        <div className="mt-8">
          <h1 className="font-bold text-3xl">Instructions</h1>
          <ul className="list-decimal ml-6 mt-4">
            {instructions.map((instruction, index) => (
              <li key={index} className="mb-2 text-xl">
                {instruction}
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default DetailsPage;
