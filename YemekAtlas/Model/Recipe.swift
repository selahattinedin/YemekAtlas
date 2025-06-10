import Foundation

struct Recipe: Identifiable, Codable {
    var id: String?
    var firestoreDocumentId: String?
    let name: String
    let ingredients: [String]
    let calories: Int
    let protein: Int
    let carbohydrates: Int
    let fat: Int
    let allergens: [String]
    let instructions: String
    let imageURL: String
    let clock: Int
    let isChefSpecial: Bool
    
    init(name: String, ingredients: [String], calories: Int, protein: Int, carbohydrates: Int, fat: Int, allergens: [String], instructions: String, imageURL: String, clock: Int, isChefSpecial: Bool = false) {
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
        self.isChefSpecial = isChefSpecial
    }
} 