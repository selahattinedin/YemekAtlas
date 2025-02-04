//
//  foodcategory.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 4.02.2025.
//

import Foundation
import SwiftUI




// MARK: - View Models
class IngredientsViewModel: ObservableObject {
    @Published var selectedCategory: String = "Sebzeler"
    @Published var selectedIngredients: Set<String> = []
    
    let categories = [
        FoodCategory(name: "Sebzeler", image: "leaf"),
        FoodCategory(name: "Balık", image: "fish"),
        FoodCategory(name: "Et & Süt", image: "meat"),
        FoodCategory(name: "Bakliyat", image: "grain"),
        FoodCategory(name: "Baharatlar", image: "spice")
    ]
    
    let ingredients: [Ingredient] = [
        Ingredient(name: "Soğan", image: "onion", category: "Sebzeler"),
        Ingredient(name: "Kabak", image: "zucchini", category: "Sebzeler"),
        // Diğer malzemeler buraya eklenecek
    ]
    
    var filteredIngredients: [Ingredient] {
        ingredients.filter { $0.category == selectedCategory }
    }
}
