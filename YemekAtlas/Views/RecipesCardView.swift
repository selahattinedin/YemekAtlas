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
        VStack(alignment: .leading, spacing: 6) {
            Image("yemek")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .clipped()
                .cornerRadius(10)
            
            Text(recipe.name)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)
            
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
                Text("\(recipe.calories) kcal")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Spacer()
                if recipe.allergens.first != " " {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .frame(width: 150)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    RecipesCardView(recipe:  Recipe(
        name: "Dummy Recipe",
        ingredients: ["Ingredient 1", "Ingredient 2"],
        calories: 200,
        protein: 15,
        carbohydrates: 30,
        fat: 10,
        allergens: ["Peanuts"],
        instructions: "Mix ingredients and cook.",
        imageURL: "",
        clock: 15
))
}
