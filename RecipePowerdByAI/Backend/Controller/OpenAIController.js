require("dotenv").config;
const OpenAI = require("openai");

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const getRecipes = async (req, res) => {
  try {
    const { prompt } = req.query;
    if (!prompt || prompt === "") {
      console.error("No prompt was inserted");
      return res.status(400).send("No prompt was inserted");
    }

    const completion = await openai.chat.completions.create({
      model: "gpt-4o", // Ensure the model is correct
      messages: [
        { role: "system", content: "You are a helpful assistant." },
        {
          role: "user",
          content: `Give me at least 5 recipe ideas in JSON format for ${prompt} without mentioning the servings, make the instructions sound more human and detailed, also add the aproximate minutes it would take.`,
        },
      ],
      response_format: {
        type: "json_schema",
        json_schema: {
          name: "recipes",
          schema: {
            type: "object",
            properties: {
              recipes: {
                description: "A list of recipe objects",
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    id: {
                      description: "Random unique UUIDV4",
                      type: "string",
                    },
                    name: {
                      description: "The name of the recipe",
                      type: "string",
                    },
                    ingredients: {
                      description: "The list of ingredients for the recipe",
                      type: "array",
                      items: {
                        type: "string",
                      },
                    },
                    instructions: {
                      description:
                        "The list of preparation steps for the recipe",
                      type: "array",
                      items: {
                        type: "string",
                      },
                    },
                    preparationTime: {
                      description:
                        "An aproximation of preparation time finished with m",
                      type: "string",
                    },
                    isFavorite: {
                      description: "always false",
                      type: "boolean",
                    },
                  },
                  required: ["name", "ingredients", "instructions"],
                  additionalProperties: false,
                },
              },
            },
            additionalProperties: false,
          },
        },
      },
    });

    const generatedText = completion.choices[0].message.content;
    let recipe;
    try {
      recipes = JSON.parse(generatedText);
    } catch (e) {
      console.error("Failed to parse generated text into JSON");
      return res.status(400).send("Failed to parse generated text into JSON");
    }

    if (!recipes) {
      console.error("No recipies were generated");
      return res.status(400).send("No recipies were generated");
    }
    return res.status(200).json(recipes);
  } catch (err) {
    console.error("Unexpected error at creating recipes");
    res
      .status(400)
      .send({ err, message: "Unexpected error at creating recipes" });
  }
};

module.exports = { getRecipes };
