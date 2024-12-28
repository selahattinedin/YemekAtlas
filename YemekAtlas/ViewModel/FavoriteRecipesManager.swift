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

    func toggleFavorite(recipe: Recipe) {
        if let index = favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
            favoriteRecipes.remove(at: index)
        } else {
            favoriteRecipes.append(recipe)
        }
        saveFavoriteRecipes()
    }

    func removeFavorite(at offsets: IndexSet) {
        for index in offsets {
            if index < favoriteRecipes.count {
                favoriteRecipes.remove(at: index)
            } else {
                print("Silme işlemi sırasında hata oluştu: Geçersiz indeks.")
            }
        }
        saveFavoriteRecipes()
    }

    func isFavorite(recipe: Recipe) -> Bool {
        return favoriteRecipes.contains(where: { $0.id == recipe.id })
    }
}
