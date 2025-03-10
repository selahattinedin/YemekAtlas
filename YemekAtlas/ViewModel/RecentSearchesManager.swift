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
        recentSearches.removeAll { $0.id == recipe.id }
        
        recentSearches.insert(recipe, at: 0)
        
        if recentSearches.count > maxSearches {
            recentSearches = Array(recentSearches.prefix(maxSearches))
        }
    }
    
    func clearSearches() {
        recentSearches.removeAll()
    }
}
