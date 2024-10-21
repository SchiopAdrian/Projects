import axios from "axios";
import { createContext, useContext, useEffect, useState } from "react";

export const RecipeContext = createContext();

export const RecipeProvider = ({ children }) => {
  const [recipes, setRecipes] = useState([]);
  const [favoriteRecipes, setFavoriteRecipes] = useState([]);
  const [isRecipesLoaded, setIsRecipesLoaded] = useState(false);
  const [loading, setLoading] = useState(true);
  const api = axios.create({ baseURL: "http://localhost:5000" });
  useEffect(() => {
    if (favoriteRecipes.length > 0 && isRecipesLoaded === false) {
      return;
    }
    setLoading(true);
    api
      .get("/favoriteRecipes")
      .then((response) => {
        const parsedData = response.data.map((recipe) => {
          return {
            ...recipe,
            ingredients: JSON.parse(recipe.ingredients), // Parse ingredients string to array
            instructions: JSON.parse(recipe.instructions),
            isFavorite:true // Parse instructions string to array
          };
        });
  
        setFavoriteRecipes(parsedData);
        
      })
      .catch((e) => console.error(e))
      .finally(() => {
        setLoading(false);
        setIsRecipesLoaded(true);
      });
  }, []);

  const getRecipeById = (id) => {
    // Check if the recipe exists in favoriteRecipes first
    const favoriteRecipe = Array.isArray(favoriteRecipes) ? favoriteRecipes.find((recipe) => recipe.id === id) : null;
    
    if (favoriteRecipe) {
      console.log(favoriteRecipe)
      return favoriteRecipe; // Return if found in favoriteRecipes
    }
    
    // If not found in favoriteRecipes, search in recipes
    return recipes.find((recipe) => recipe.id === id);
  };
  const getOpenAIRecipes = async (prompt) => {
    setLoading(true);
    try {
      await api
        .get(`/recipes?prompt=${encodeURIComponent(prompt)}`)
        .then((response) => {
          setRecipes(response.data.recipes);
          console.log(recipes);
        });
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  const addToFavoriteRecipes = async (newFavoriteRecipe) => {
    setLoading(true);
    try {
      const response = await api.post("/favoriteRecipe", {
        id: newFavoriteRecipe.id,
        name: newFavoriteRecipe.name,
        ingredients: newFavoriteRecipe.ingredients,
        instructions: newFavoriteRecipe.instructions,
        preparationTime: newFavoriteRecipe.preparationTime,
      });
      if (response.status === 200) {
        setFavoriteRecipes(favoriteRecipes.push(newFavoriteRecipe));
        setRecipes((prevRecipe) =>
          prevRecipe.map((recipe) =>
            recipe.id === newFavoriteRecipe.id
              ? { ...recipe, isFavorite: true }
              : recipe
          )
        );
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  const deleteFromFavoriteRecipies = async (id) => {
    setLoading(true);
    console.log(id);
    try {
      const response = await api.delete(`/favoriteRecipe/${id}`);
      if (response.status === 200) {
        setFavoriteRecipes((prevRecipes) =>
          Array.isArray(prevRecipes)
            ? prevRecipes.filter((recipe) => recipe.id !== id)
            : []
        );
        setRecipes((prevRecipe) =>
          prevRecipe.map((recipe) =>
            recipe.id === id ? { ...recipe, isFavorite: false } : recipe
          )
        );
      }
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  const value = {
    recipes,
    favoriteRecipes,
    loading,
    getOpenAIRecipes,
    addToFavoriteRecipes,
    deleteFromFavoriteRecipies,
    getRecipeById,
  };

  return (
    <RecipeContext.Provider value={value}>{children}</RecipeContext.Provider>
  );
};

export const useRecipeContext = () => useContext(RecipeContext);
