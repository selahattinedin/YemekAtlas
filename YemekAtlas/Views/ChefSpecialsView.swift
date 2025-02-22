//
//  ChefSpecialsView.swift
//  FoodAtlas
//
//  Created by Selahattin EDİN on 25.01.2025.
//

import SwiftUI

struct ChefSpecialsView: View {
    let specialRecipes: [Recipe] = [
        Recipe(
            name: "Margherita Pizza",
            ingredients: [
                "250 g flour",
                "150 ml water",
                "5 g yeast",
                "A pinch of salt",
                "200 g mozzarella cheese",
                "100 g tomato sauce",
                "Fresh basil leaves"
            ],
            calories: 270,
            protein: 12,
            carbohydrates: 33,
            fat: 10,
            allergens: ["Gluten", "Dairy"],
            instructions: """
            1. Mix flour, water, yeast, and salt to prepare a smooth dough.
            2. Let the dough rest for 30 minutes.
            3. Roll out the dough and spread tomato sauce on top.
            4. Add mozzarella cheese and bake at 220°C for 10-12 minutes.
            5. Garnish with fresh basil leaves and serve.
            """,
            imageURL: "Pizza",
            clock: 20
        ),
        Recipe(
            name: "Sushi",
            ingredients: [
                "200 g sushi rice",
                "50 ml rice vinegar",
                "1 teaspoon sugar",
                "1 teaspoon salt",
                "Nori seaweed",
                "200 g salmon",
                "Avocado slices"
            ],
            calories: 180,
            protein: 15,
            carbohydrates: 30,
            fat: 5,
            allergens: ["Fish"],
            instructions: """
            1. Rinse the rice and cook it by boiling.
            2. Mix rice vinegar, sugar, and salt, then add to the hot rice.
            3. Spread the rice thinly over the nori seaweed.
            4. Add salmon and avocado slices, then roll.
            5. Slice and serve.
            """,
            imageURL: "Sushi",
            clock: 30
        ),
        Recipe(
            name: "Hamburger",
            ingredients: [
                "1 hamburger bun",
                "150 g ground beef",
                "1 slice cheddar cheese",
                "2 slices tomato",
                "1 lettuce leaf",
                "Ketchup and mayonnaise"
            ],
            calories: 450,
            protein: 25,
            carbohydrates: 40,
            fat: 20,
            allergens: ["Gluten", "Dairy"],
            instructions: """
            1. Shape the ground beef into a patty and cook in a pan.
            2. Slice the hamburger bun in half and toast it.
            3. Place lettuce, tomato slices, the cooked patty, and cheddar cheese on the bottom bun.
            4. Add ketchup and mayonnaise, then close with the top bun.
            """,
            imageURL: "Hamburger",
            clock: 20
        ),
        Recipe(
            name: "Tacos",
            ingredients: [
                "2 tortillas",
                "150 g chicken breast",
                "50 g corn",
                "50 g tomato",
                "50 g onion",
                "1 teaspoon taco seasoning"
            ],
            calories: 250,
            protein: 20,
            carbohydrates: 30,
            fat: 8,
            allergens: ["Gluten"],
            instructions: """
            1. Cut the chicken breast into small pieces and marinate with taco seasoning.
            2. Cook the chicken in a pan.
            3. Fill the tortillas with chicken, corn, tomato, and onion.
            4. Add sauce if desired and serve.
            """,
            imageURL: "Tacos",
            clock: 15
        ),
        Recipe(
            name: "Pad Thai",
            ingredients: [
                "200 g rice noodles",
                "100 g shrimp",
                "2 tablespoons soy sauce",
                "1 tablespoon fish sauce",
                "1 egg",
                "50 g peanuts"
            ],
            calories: 380,
            protein: 22,
            carbohydrates: 50,
            fat: 12,
            allergens: ["Soy", "Fish", "Egg", "Peanuts"],
            instructions: """
            1. Boil and drain the rice noodles.
            2. Scramble the egg in a pan.
            3. Add shrimp, soy sauce, and fish sauce, then mix well.
            4. Add the boiled noodles to the pan.
            5. Sprinkle peanuts on top and serve.
            """,
            imageURL: "PadThai",
            clock: 25
        )
    ]

    var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Chef's Specials")
                    .font(.title2.bold())
                    .foregroundColor(.orange)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(specialRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipesCardView(recipe: recipe)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 16)
        }
    }

#Preview {
    ChefSpecialsView()
}
