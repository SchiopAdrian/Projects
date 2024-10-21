import React from "react";
import ReactDOM from "react-dom/client";

import "./index.scss";
import { RouterProvider } from "react-router-dom";
import { router } from "./router/Router";
import { RecipeProvider } from "./contexts/recipeContext";

const App = () => {
  return(
    <RecipeProvider>
      <RouterProvider router={router}/>
    </RecipeProvider>
  )
};
const rootElement = document.getElementById("app")
if (!rootElement) throw new Error("Failed to find the root element")

const root = ReactDOM.createRoot(rootElement)

root.render(<App />)