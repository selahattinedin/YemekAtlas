import Foundation
import FirebaseFirestore
import SwiftUI

struct Recipe: Codable, Identifiable, Equatable, Hashable {
    var id: String
    var firestoreDocumentId: String?
    let name: String // Burada String olarak kalmalı
    let ingredients: [String]
    let calories: Int
    let protein: Int
    let carbohydrates: Int
    let fat: Int
    let allergens: [String]
    let instructions: String
    let imageURL: String
    let clock: Int
    
    // Computed properties for localized access
    var localizedName: LocalizedStringKey {
        LocalizedStringKey(name)
    }
    
    var localizedIngredients: [LocalizedStringKey] {
        ingredients.map { LocalizedStringKey($0) }
    }
    
    var localizedAllergens: [LocalizedStringKey] {
        allergens.map { LocalizedStringKey($0) }
    }
    
    var localizedInstructions: LocalizedStringKey {
        LocalizedStringKey(instructions)
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         ingredients: [String],
         calories: Int,
         protein: Int,
         carbohydrates: Int,
         fat: Int,
         allergens: [String],
         instructions: String,
         imageURL: String,
         clock: Int) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.allergens = allergens
        self.instructions = instructions
        self.imageURL = imageURL
        self.clock = clock
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
