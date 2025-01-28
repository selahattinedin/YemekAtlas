//
//  File.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 28.01.2025.
//

import Foundation


class RecentSearchesManager: ObservableObject {
    @Published var recentSearches: [Recipe] = []
    private let maxSearches = 10
    
    func addSearch(_ recipe: Recipe) {
        // Remove if already exists to avoid duplicates
        recentSearches.removeAll { $0.id == recipe.id }
        
        // Add new recipe at the beginning
        recentSearches.insert(recipe, at: 0)
        
        // Keep only the last 10 searches
        if recentSearches.count > maxSearches {
            recentSearches = Array(recentSearches.prefix(maxSearches))
        }
    }
    
    func clearSearches() {
        recentSearches.removeAll()
    }
}
