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
        @Published var searchQuery: String = ""
    
    let categories = [
        FoodCategory(name: "Sebzeler", image: "leaf"),
        FoodCategory(name: "Balık", image: "fish"),
        FoodCategory(name: "Et & Süt", image: "meat"),
        FoodCategory(name: "Bakliyat", image: "grain"),
        FoodCategory(name: "Baharatlar", image: "spice")
    ]
    
    let ingredients: [Ingredient] = [
        Ingredient(name: "Marul", imageUrl: "marul", category: "Sebzeler"),
        Ingredient(name: "Brokoli", imageUrl: "brokoli", category: "Sebzeler"),
        Ingredient(name: "Domates", imageUrl: "domates", category: "Sebzeler"),
        Ingredient(name: "Salatalık", imageUrl: "salatalik", category: "Sebzeler"),
        Ingredient(name: "Havuç", imageUrl: "havuc", category: "Sebzeler"),
        Ingredient(name: "Kabak", imageUrl: "kabak", category: "Sebzeler"),
        Ingredient(name: "Kırmızı Kapya Biber", imageUrl: "kirmizi_kapya_biber", category: "Sebzeler"),
        Ingredient(name: "Semiz Otu", imageUrl: "semiz_otu", category: "Sebzeler"),
        Ingredient(name: "Soğan", imageUrl: "sogan", category: "Sebzeler"),
        Ingredient(name: "Limon", imageUrl: "limon", category: "Sebzeler"),
        Ingredient(name: "Karnabahar", imageUrl: "karnabahar", category: "Sebzeler"),
        Ingredient(name: "Yeşil Fasulye", imageUrl: "yesil_fasulye", category: "Sebzeler"),
        Ingredient(name: "Ispanak", imageUrl: "ispanak", category: "Sebzeler"),
        Ingredient(name: "Mantar", imageUrl: "mantar", category: "Sebzeler"),
        Ingredient(name: "Dana Ciğer", imageUrl: "dana_ciger", category: "Et & Süt"),
        Ingredient(name: "Kuşbaşı", imageUrl: "kusbasi", category: "Et & Süt"),
        Ingredient(name: "Kıyma", imageUrl: "kiyma", category: "Et & Süt"),
        Ingredient(name: "Biftek", imageUrl: "biftek", category: "Et & Süt"),
        Ingredient(name: "Nohut", imageUrl: "nohut", category: "Bakliyat"),
        Ingredient(name: "Bezelye", imageUrl: "bezelye", category: "Bakliyat"),
        Ingredient(name: "Pirinç", imageUrl: "pirinc", category: "Bakliyat"),


        
    ]
    
    var filteredIngredients: [Ingredient] {
            let categoryFiltered = ingredients.filter { $0.category == selectedCategory }
            
            if searchQuery.isEmpty {
                return categoryFiltered
            }
            
            return categoryFiltered.filter { ingredient in
                ingredient.name.lowercased().contains(searchQuery.lowercased())
            }
        }
    }
    
    

