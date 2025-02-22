import Foundation
import SwiftUI

class IngredientsViewModel: ObservableObject {
    @Published var selectedCategory: String = "Vegetables"
    @Published var selectedIngredients: Set<String> = []
    @Published var searchQuery: String = ""
    
    let categories = [
        FoodCategory(name: "Vegetables", image: "leaf"),
        FoodCategory(name: "Fish", image: "fish"),
        FoodCategory(name: "Meat & Dairy", image: "meat"),
        FoodCategory(name: "Legumes", image: "grain"),
        FoodCategory(name: "Spices", image: "spice")
    ]
    
    let ingredients: [Ingredient] = [
        // Vegetables
        Ingredient(name: "Lettuce", imageUrl: "marul", category: "Vegetables"),
        Ingredient(name: "Broccoli", imageUrl: "brokoli", category: "Vegetables"),
        Ingredient(name: "Tomato", imageUrl: "domates", category: "Vegetables"),
        Ingredient(name: "Cucumber", imageUrl: "salatalik", category: "Vegetables"),
        Ingredient(name: "Carrot", imageUrl: "havuc", category: "Vegetables"),
        Ingredient(name: "Zucchini", imageUrl: "kabak", category: "Vegetables"),
        Ingredient(name: "Red Bell Pepper", imageUrl: "kirmizi_kapya_biber", category: "Vegetables"),
        Ingredient(name: "Purslane", imageUrl: "semiz_otu", category: "Vegetables"),
        Ingredient(name: "Onion", imageUrl: "sogan", category: "Vegetables"),
        Ingredient(name: "Lemon", imageUrl: "limon", category: "Vegetables"),
        Ingredient(name: "Cauliflower", imageUrl: "karnabahar", category: "Vegetables"),
        Ingredient(name: "Green Beans", imageUrl: "yesil_fasulye", category: "Vegetables"),
        Ingredient(name: "Spinach", imageUrl: "ispanak", category: "Vegetables"),
        Ingredient(name: "Mushrooms", imageUrl: "mantar", category: "Vegetables"),

        // Meat & Dairy
        Ingredient(name: "Beef Liver", imageUrl: "dana_ciger", category: "Meat & Dairy"),
        Ingredient(name: "Cubed Meat", imageUrl: "kusbasi", category: "Meat & Dairy"),
        Ingredient(name: "Ground Meat", imageUrl: "kiyma", category: "Meat & Dairy"),
        Ingredient(name: "Steak", imageUrl: "biftek", category: "Meat & Dairy"),

        // Legumes
        Ingredient(name: "Chickpeas", imageUrl: "nohut", category: "Legumes"),
        Ingredient(name: "Peas", imageUrl: "bezelye", category: "Legumes"),
        Ingredient(name: "Rice", imageUrl: "pirinc", category: "Legumes"),
        Ingredient(name: "Sausage", imageUrl: "sosis", category: "Legumes"),
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
