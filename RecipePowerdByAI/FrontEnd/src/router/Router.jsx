import { createBrowserRouter } from "react-router-dom";
import MainPage from "../pages/MainPage";
import DetailsPage from "../pages/DetailsPage";

export const router = createBrowserRouter([
  {
    path: "/",
    element: <MainPage />,
  },
  {
    path: "/recipes/:id",
    element: <DetailsPage/>
  }
]);
