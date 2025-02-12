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
        Ingredient(name: "Marul", imageUrl: "marul", category: "Sebzeler"),
        Ingredient(name: "Hamsi", imageUrl: "zucchini", category: "Balık"),
        Ingredient(name: "Domates", imageUrl: "domates", category: "Sebzeler"),
        Ingredient(name: "Salatalık", imageUrl: "domates", category: "Sebzeler"),
        Ingredient(name: "Karabiber", imageUrl: "domates", category: "Baharatlar"),
        Ingredient(name: "Kabak", imageUrl: "domates", category: "Sebzeler"),
        Ingredient(name: "Kabak", imageUrl: "domates", category: "Sebzeler"),
        Ingredient(name: "Kabak", imageUrl: "domates", category: "Sebzeler"),
        Ingredient(name: "Kabak", imageUrl: "domates", category: "Sebzeler")

        
    ]
    
    var filteredIngredients: [Ingredient] {
        ingredients.filter { $0.category == selectedCategory }
    }
}
