//
//  RecipesCardView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.01.2025.
//

import SwiftUI

struct RecipesCardView: View {
    let recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottom) {
            // Full bleed image
            Image(recipe.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 185, height: 190)
                .clipped()
                .cornerRadius(16)

            // Dark gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(16)

            // Content overlay
            VStack(alignment: .leading, spacing: 6) {
                Spacer()

                // Recipe name
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Calories and allergen info
                HStack {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(recipe.calories) kcal")
                            .foregroundColor(.white)
                    }
                    .font(.caption)

                    Spacer()

                    if !recipe.allergens.isEmpty {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            .padding(10)
        }
        .frame(width: 185, height: 200)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    HStack(spacing: 16) {
        RecipesCardView(recipe: Recipe(
            name: "Chicken Salad",
            ingredients: ["Chicken", "Lettuce", "Tomatoes"],
            calories: 350,
            protein: 25,
            carbohydrates: 15,
            fat: 12,
            allergens: ["Nuts"],
            instructions: "Mix and serve",
            imageURL: "",
            clock: 20
        ))
        RecipesCardView(recipe: Recipe(
            name: "Margherita Pizza",
            ingredients: ["Dough", "Tomato Sauce", "Mozzarella"],
            calories: 270,
            protein: 12,
            carbohydrates: 30,
            fat: 10,
            allergens: [],
            instructions: "Bake and serve",
            imageURL: "",
            clock: 30
        ))
    }
}
