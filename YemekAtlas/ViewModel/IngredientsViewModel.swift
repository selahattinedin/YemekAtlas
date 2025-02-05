//
//  foodcategory.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 4.02.2025.
//

import Foundation
import SwiftUI

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
        Ingredient(name: "Marul", image: "marul", category: "Sebzeler"),
        Ingredient(name: "Hamsi", image: "zucchini", category: "Balık"),
        Ingredient(name: "Domates", image: "domates", category: "Sebzeler"),
        Ingredient(name: "Salatalık", image: "domates", category: "Sebzeler"),
        Ingredient(name: "Karabiber", image: "domates", category: "Baharatlar"),
        Ingredient(name: "Kabak", image: "domates", category: "Sebzeler"),
        Ingredient(name: "Kabak", image: "domates", category: "Sebzeler"),
        Ingredient(name: "Kabak", image: "domates", category: "Sebzeler"),
        Ingredient(name: "Kabak", image: "domates", category: "Sebzeler")

        
    ]
    
    var filteredIngredients: [Ingredient] {
        ingredients.filter { $0.category == selectedCategory }
    }
}
