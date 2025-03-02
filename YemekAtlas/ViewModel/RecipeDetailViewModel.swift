//
//  RecipeDetailViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 2.03.2025.
//

import Foundation
class RecipeDetailViewModel: ObservableObject {
    @Published var selectedTab = "Ingredients"
    @Published var selectedIngredients: Set<String> = []
    @Published var isFavorite = false
    
    let tabs = ["Ingredients", "Instructions", "Allergens"]
    private var favoritesManager = FavoriteRecipesManager()
    private var recipe: Recipe?
    
    
    
    func toggleIngredient(_ ingredient: String) {
        if selectedIngredients.contains(ingredient) {
            selectedIngredients.remove(ingredient)
        } else {
            selectedIngredients.insert(ingredient)
        }
    }
}
