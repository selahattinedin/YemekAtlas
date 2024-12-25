//
//  PopularRecipesView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.12.2024.
//

import SwiftUI

struct PopularRecipesView: View {
    struct PopularRecipe: Identifiable {
        let id = UUID()
        let name: String
        let image: String
        let rating: Double
        let recipe: Recipe
    }
    
    @State private var popularRecipes = [
        PopularRecipe(
            name: "Creamy Pasta",
            image: "yemek",
            rating: 4.5,
            recipe: Recipe(
                name: "Creamy Pasta",
                ingredients: ["1 lb penne pasta", "3 tbsp butter", "2 cups heavy cream"],
                calories: 340,
                protein: 12,
                carbohydrates: 45,
                fat: 18,
                allergens: ["Dairy", "Gluten"],
                instructions: """
                Boil pasta,
                Make cream sauce,
                Combine and serve
                """,
                imageURL: "creamy_pasta"
            )
        ),
        PopularRecipe(
            name: "Curry Soup",
            image: "yemek",
            rating: 4.8,
            recipe: Recipe(
                name: "Curry Soup",
                ingredients: ["Vegetables", "Coconut milk", "Curry paste"],
                calories: 280,
                protein: 8,
                carbohydrates: 35,
                fat: 12,
                allergens: ["Coconut"],
                instructions: """
                Cook vegetables,
                Add curry, 
                Simmer
                """,
                imageURL: "curry_soup"
            )
        ),
        
        PopularRecipe(
            name: "Creamy Pasta",
            image: "yemek",
            rating: 4.5,
            recipe: Recipe(
                name: "Creamy Pasta",
                ingredients: ["1 lb penne pasta", "3 tbsp butter", "2 cups heavy cream"],
                calories: 340,
                protein: 12,
                carbohydrates: 45,
                fat: 18,
                allergens: ["Dairy", "Gluten"],
                instructions: """
                Boil pasta,
                Make cream sauce,
                Combine and serve
                """,
                imageURL: "creamy_pasta"
            )
        ),
        PopularRecipe(
            name: "Curry Soup",
            image: "yemek",
            rating: 4.8,
            recipe: Recipe(
                name: "Curry Soup",
                ingredients: ["Vegetables", "Coconut milk", "Curry paste"],
                calories: 280,
                protein: 8,
                carbohydrates: 35,
                fat: 12,
                allergens: ["Coconut"],
                instructions: """
                Cook vegetables,
                Add curry, 
                Simmer
                """,
                imageURL: "curry_soup"
            )
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Popüler Tarifler")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 20), // Yatay boşlukları artırdık
                GridItem(.flexible(), spacing: 30) // Yatay boşlukları artırdık
            ], spacing: 10) { // Dikey boşluğu artırdık
                ForEach(popularRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe.recipe)) {
                        RecipeCard(recipe: recipe)
                            .padding(5) // Kartların çevresine ekstra boşluk ekledik
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RecipeCard: View {
    let recipe: PopularRecipesView.PopularRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) { // İçerik aralığını biraz daralttık
            Image(recipe.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100) // Yüksekliği küçülttük
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Köşe yarıçapını küçülttük
                .overlay(
                    Button(action: {
                        // Handle favorite action
                    }) {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                            .padding(6) // Butonun boyutunu küçülttük
                            .background(Color.white.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(6),
                    alignment: .topTrailing
                )
            
            Text(recipe.name)
                .font(.system(size: 14, weight: .semibold)) // Yazı boyutunu küçülttük
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 12)) // Yıldız boyutunu küçülttük
                Text(String(format: "%.1f", recipe.rating))
                    .font(.system(size: 12, weight: .medium)) // Yazı boyutunu küçülttük
                    .foregroundColor(.secondary)
            }
        }
        .padding(10) // Genel padding’i küçülttük
        .background(Color.white)
        .cornerRadius(12) // Köşe yarıçapını küçülttük
        .shadow(color: Color.black.opacity(0.1), radius: 3) // Gölgeyi azalttık
    }
}

#Preview {
    PopularRecipesView()
}
