//
//  DailyRecipeCardView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 17.02.2025.
//

import SwiftUI

struct DailyRecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
            HStack(spacing: 0) {
               
                Image("Hamburger")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipped()
                    .cornerRadius(12)
                    
                VStack(alignment: .leading, spacing: 12) {
                    Text(LocalizedStringKey(recipe.name))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 12) {
                        
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text(LocalizedStringKey("\(recipe.clock) Min."))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 1))
                        
                        
                        HStack(spacing: 6) {
                            Image(systemName: "flame")
                                .foregroundColor(.gray)
                            Text(LocalizedStringKey("\(recipe.calories) cal"))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 16).stroke(Color.gray, lineWidth: 1))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
            }
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("foodbackcolor"), lineWidth: 2)
            )
            .padding(.horizontal)
        }
    }
}

#Preview {
    DailyRecipeCardView(recipe: Recipe(name: "test_recipe", ingredients: [""], calories: 0, protein: 0, carbohydrates: 0, fat: 0, allergens: [""], instructions: "", imageURL: "", clock: 0))
}
