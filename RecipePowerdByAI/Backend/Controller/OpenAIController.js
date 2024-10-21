require('dotenv').config;
const OpenAI = require('openai');

const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY
})

const getRecipes = async(req,res) =>{
    try{
        
        const { prompt } = req.query;
        if(!prompt || prompt === ''){
            console.error('No prompt was inserted');
            return res.status(400).send('No prompt was inserted');
        }
        
        const completion = await openai.chat.completions.create({
            model: 'gpt-4o',  // Ensure the model is correct
            messages: [
                { role: 'system', content: 'You are a helpful assistant.' },
                { role: 'user', content: `Give me at least 5 recipe ideas in JSON format for ${prompt} without mentioning the servings, make the instructions sound more human and detailed, also add the aproximate minutes it would take.` }
            ],
            response_format:{
                "type": "json_schema",
                "json_schema": {
                  "name": "recipes",
                  "schema": {
                    "type": "object",
                    "properties": {
                      "recipes": {
                        "description": "A list of recipe objects",
                        "type": "array",
                        "items": {
                          "type": "object",
                          "properties": {
                            "id":{
                              "description":"Random unique UUIDV4",
                              "type": "string"
                            },
                            "name": {
                              "description": "The name of the recipe",
                              "type": "string"
                            },
                            "ingredients": {
                              "description": "The list of ingredients for the recipe",
                              "type": "array",
                              "items": {
                                "type": "string"
                              }
                            },
                            "instructions": {
                              "description": "The list of preparation steps for the recipe",
                              "type": "array",
                              "items": {
                                "type": "string"
                              }
                            },
                            "preparationTime": {
                              "description": "An aproximation of preparation time finished with m",
                              "type": "string",
      
                            },
                            "isFavorite":{
                              "description": "always false",
                              "type": "boolean"
                            }
                            
                          },
                          "required": ["name", "ingredients", "instructions"],
                          "additionalProperties": false
                        }
                      }
                    },
                    "additionalProperties": false
                  }
                },
              }
          
        });
        
        const generatedText = completion.choices[0].message.content;
        let recipe
        try{
            recipes = JSON.parse(generatedText);
        } catch (e) {
            console.error('Failed to parse generated text into JSON');
            return res.status(400).send('Failed to parse generated text into JSON');
        }

        if(!recipes){
            console.error('No recipies were generated');
            return res.status(400).send('No recipies were generated');
        }
        return res.status(200).json(recipes);
    }catch(err){
        console.error('Unexpected error at creating recipes');
        res.status(400).send({err, message:'Unexpected error at creating recipes'})
    }
}

const getPremadeRecipes = async(req,res)=>{
  const recipes =  [
    {
        "id": "31d31f22-bd91-4f48-9991-3e62dcd8ce1f",
        "name": "Spaghetti Carbonara",
        "ingredients": [
            "200g spaghetti",
            "100g pancetta",
            "2 large eggs",
            "50g Pecorino cheese",
            "50g Parmesan",
            "Black pepper",
            "Salt"
        ],
        "instructions": [
            "First, cook the spaghetti in a large pan of boiling salted water until al dente. This should take about 10 minutes.",
            "As the pasta is cooking, chop the pancetta if it's not already in small cubes. Heat a little olive oil in a pan, add the pancetta, and fry until crispy and golden.",
            "In a bowl, beat the eggs, then add the finely grated Pecorino and Parmesan cheeses. Mix well and season with pepper.",
            "Once the pasta is cooked, reserve a cup of the pasta water and drain the rest.",
            "Quickly add the hot pasta to the pan with the pancetta, then remove the pan from the heat.",
            "Pour the egg and cheese mixture over the pasta, using the pasta water to help create a creamy sauce. Stir quickly so the eggs don't scramble.",
            "Taste and season with a little more salt and pepper, then serve immediately with a sprinkling of extra cheese."
        ],
        "preparationTime": "20m",
        "isFavorite": false
    },
    {
        "id": "4cd17fa8-a001-4f53-8df7-9c1ed4b7cdf3",
        "name": "Caprese Salad",
        "ingredients": [
            "600g ripe tomatoes",
            "250g fresh mozzarella cheese",
            "Basil leaves",
            "Salt",
            "Pepper",
            "Olive oil"
        ],
        "instructions": [
            "Start by slicing the tomatoes and mozzarella cheese into thick slices.",
            "Arrange the tomato and mozzarella slices on a plate, alternating between the two.",
            "Tuck fresh basil leaves between the slices for a pop of color and flavor.",
            "Season the salad with salt and freshly ground black pepper.",
            "Drizzle the whole salad generously with good quality olive oil.",
            "Serve immediately to enjoy the freshness of the ingredients."
        ],
        "preparationTime": "10m",
        "isFavorite": false
    },
    {
        "id": "5b6e0b69-e7b5-41e5-bf30-c23d6f7602e4",
        "name": "Chicken Curry",
        "ingredients": [
            "500g chicken breast",
            "2 onions",
            "3 garlic cloves",
            "1 thumb-sized piece of ginger",
            "2 tbsp curry powder",
            "400ml coconut milk",
            "Salt",
            "Pepper",
            "Coriander leaves"
        ],
        "instructions": [
            "Chop the onions, garlic, and ginger finely. Cut the chicken breast into bite-sized pieces.",
            "In a large pot, heat some oil and add the onions. Cook until they are soft and translucent, about 5 minutes.",
            "Add the chopped garlic and ginger, and cook for another 2 minutes until fragrant.",
            "Sprinkle the curry powder over the mixture and stir well to coat the onions.",
            "Add the chicken pieces into the pot and cook until browned on the outside.",
            "Pour the coconut milk into the pot. Stir well, bring to a simmer, then lower the heat and let it gently bubble for about 20 minutes.",
            "Add salt and pepper to taste. If you prefer more heat, add a pinch of chili flakes.",
            "Once the chicken is cooked through and the sauce has thickened to your liking, sprinkle some fresh coriander leaves on top and serve with rice."
        ],
        "preparationTime": "35m",
        "isFavorite": false
    },
    {
        "id": "2ee3139b-0e8b-45bf-b8af-8567ded9af02",
        "name": "Vegetable Stir Fry",
        "ingredients": [
            "1 red bell pepper",
            "100g broccoli florets",
            "1 carrot",
            "200g snap peas",
            "2 garlic cloves",
            "2 tbsp soy sauce",
            "1 tbsp sesame oil",
            "Sesame seeds"
        ],
        "instructions": [
            "Start by slicing the bell pepper and carrot into thin strips. Halve any large broccoli florets.",
            "Heat a wok or large frying pan over high heat and add the sesame oil.",
            "Add the garlic cloves, minced, to the pan and stir for 30 seconds until aromatic.",
            "Toss in the broccoli and carrot, stir-frying them for about 2 minutes.",
            "Add the bell pepper and snap peas, continuing to stir-fry for another 3 minutes.",
            "Pour the soy sauce over the vegetables, mixing everything so that the sauce coats all the veggies.",
            "Continue cooking for another 2 minutes until the vegetables are tender but still crisp.",
            "Transfer to a plate and sprinkle with sesame seeds before serving."
        ],
        "preparationTime": "15m",
        "isFavorite": false
    },
    {
        "id": "cee1e4d2-50a0-4eec-b3f1-935eebd6c3e1",
        "name": "Chocolate Chip Cookies",
        "ingredients": [
            "125g butter",
            "100g brown sugar",
            "100g white sugar",
            "1 egg",
            "1 tsp vanilla extract",
            "225g plain flour",
            "1/2 tsp baking soda",
            "A pinch of salt",
            "200g chocolate chips"
        ],
        "instructions": [
            "Preheat your oven to 180°C (350°F).",
            "In a large bowl, cream the butter and sugars together until light and fluffy.",
            "Beat in the egg and vanilla extract until well combined.",
            "In another bowl, mix together the flour, baking soda, and salt.",
            "Gradually add the dry ingredients to the wet ingredients, stirring until just combined.",
            "Fold in the chocolate chips evenly throughout the dough.",
            "Spoon tablespoons of dough onto a baking tray lined with parchment paper, leaving space for spreading.",
            "Bake in the preheated oven for 10-12 minutes or until the edges are golden brown.",
            "Allow the cookies to cool on the tray for a few minutes before transferring to a wire rack to cool completely."
        ],
        "preparationTime": "25m",
        "isFavorite": false
    }
  ]
  res.status(200).json({recipes:recipes});
}
module.exports = {getRecipes, getPremadeRecipes}