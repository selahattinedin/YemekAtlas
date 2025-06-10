import Foundation

struct SpecialRecipe: Identifiable {
    let id = UUID()
    let name: String
    let ingredients: [String]
    let calories: Int
    let protein: Int
    let carbohydrates: Int
    let fat: Int
    let allergens: [String]
    let instructions: String
    let imageURL: String // Bu her zaman asset ismi olacak
    let clock: Int
    
    // Recipe'ye dönüştürme fonksiyonu
    func toRecipe() -> Recipe {
        Recipe(
            name: name,
            ingredients: ingredients,
            calories: calories,
            protein: protein,
            carbohydrates: carbohydrates,
            fat: fat,
            allergens: allergens,
            instructions: instructions,
            imageURL: imageURL,
            clock: clock
        )
    }
} 