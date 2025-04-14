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
            VStack(spacing: 0) {
                
                ZStack(alignment: .topTrailing) {
                  
                    Image("Hamburger")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                    
                  
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text(LocalizedStringKey("\(recipe.clock) Min"))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(20)
                    .padding(12)
                }
                
                
                VStack(alignment: .leading, spacing: 10) {
                   
                    Text(recipe.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                   
                    HStack(spacing: 12) {
                      
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text(LocalizedStringKey("\(recipe.calories) kcal"))
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        
                    
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                                .font(.caption)
                            Text(LocalizedStringKey("\(recipe.clock) Min"))
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(12)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DailyRecipeCardView(recipe: Recipe(
        name: "Ev Yapımı Hamburger",
        ingredients: ["Dana kıyma", "Soğan", "Sarımsak", "Mayonez", "Domates", "Marul"],
        calories: 450,
        protein: 25,
        carbohydrates: 35,
        fat: 20,
        allergens: ["Gluten", "Süt Ürünü", "Yumurta"],
        instructions: "Kıymayı soğan ve sarımsakla karıştırıp...",
        imageURL: "",
        clock: 30
    ))
    .previewLayout(.sizeThatFits)
    .padding()
    .background(Color.gray.opacity(0.1))
}
