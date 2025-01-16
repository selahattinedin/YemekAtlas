//
//  FavoriteRecipesManager.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 27.12.2024.
//

import Foundation

class FavoriteRecipesManager: ObservableObject {
    @Published var favoriteRecipes: [Recipe] = []
    private let userDefaultsKey = "FavoriteRecipes"

    init() {
        loadFavoriteRecipes()
    }

    func loadFavoriteRecipes() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            favoriteRecipes = recipes
        }
    }

    func saveFavoriteRecipes() {
        if let encodedData = try? JSONEncoder().encode(favoriteRecipes) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    // Favori tarifi eklerken içerik kontrolü yapıyoruz.
    func toggleFavorite(recipe: Recipe) {
        // Aynı isim ve içeriklere sahip tarifin tekrar eklenmesini engelliyoruz.
        if !favoriteRecipes.contains(where: { $0.name == recipe.name && $0.ingredients == recipe.ingredients }) {
            // Tarif favorilerde yoksa, başa ekle
            favoriteRecipes.insert(recipe, at: 0)
        }
        saveFavoriteRecipes()
    }

    func removeFavorite(at offsets: IndexSet) {
        for index in offsets {
            if index < favoriteRecipes.count {
                favoriteRecipes.remove(at: index)
            }
        }
        saveFavoriteRecipes()
    }

    func isFavorite(recipe: Recipe) -> Bool {
        return favoriteRecipes.contains(where: { $0.name == recipe.name && $0.ingredients == recipe.ingredients })
    }
}
