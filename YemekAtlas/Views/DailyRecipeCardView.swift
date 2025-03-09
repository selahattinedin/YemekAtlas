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
                // Image section with overlay
                ZStack(alignment: .topTrailing) {
                    // Hamburger image
                    Image("Hamburger")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                    
                    // Time badge
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
                
                // Content section
                VStack(alignment: .leading, spacing: 10) {
                    // Title row - beğenme butonu kaldırıldı
                    Text(recipe.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    // Nutrition info - only calories
                    HStack(spacing: 12) {
                        // Calories
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text(LocalizedStringKey("\(recipe.calories) kcal"))
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        
                        // Time info
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
