import Foundation
import GoogleGenerativeAI

class DailyRecipesViewViewModel: ObservableObject {
    @Published var dailyRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let generativeModel: GenerativeModel
    
    init() {
        generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
        Task {
            await fetchDailyRecipes()
        }
    }
    
    @MainActor
    func fetchDailyRecipes() async {
        isLoading = true
        errorMessage = nil
        dailyRecipes = []
        
        let prompt = """
                Provide information for only one recipe from world cuisine in the format below. Specifically check and mention important allergens:

                Name: [Recipe Name]

                Ingredients: 
                (List ingredients for only one recipe and put - in front of each)
                - [Ingredient and amount]

                Calories: Give an appropriate calorie count for the recipe name. [Only number] kcal

                Nutritional Values:
                Protein: [Only number] g
                Carbohydrates: [Only number] g
                Fat: [Only number] g

                Preparation Time: [Only number] minutes

                Allergens:
                [CHECK THE INGREDIENTS ONE BY ONE AND LIST BELOW:
                - If any ingredients contain gluten, shellfish, eggs, dairy products, fish, mustard, peanuts, black pepper, or soy, write them under the "Allergen:" heading.
                - Only list the allergenic substances under the Allergen heading. If none, write "Not Available".]

                Instructions:
                [Provide a detailed recipe, list it step by step with each point starting on a new line.]

                ImageURL: [URL for the food image]
                """
        
        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                // Check the response and show error message if any data is missing
                if text.contains("Name:") && text.contains("Ingredients:") && text.contains("Nutritional Values:") && text.contains("Allergens:") && text.contains("Instructions:") {
                    dailyRecipes = parseMultipleRecipesText(text)
                } else {
                    errorMessage = "The full response could not be obtained from the API. Please try again."
                }
            }
        } catch {
            errorMessage = "An error occurred while loading the recipe: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func parseMultipleRecipesText(_ text: String) -> [Recipe] {
        let recipeBlocks = text.components(separatedBy: "\n\n\n")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        let recipes = recipeBlocks.compactMap { parseRecipeText($0) }
        return Array(recipes.prefix(1))
    }
    
    private func parseRecipeText(_ text: String) -> Recipe? {
        var name = ""
        var ingredients: [String] = []
        var calories = 0
        var protein = 0
        var carbohydrates = 0
        var fat = 0
        var allergens: [String] = []
        var instructions = ""
        var imageURL = ""
        var clock = 0
        var currentSection = ""
        
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        for line in lines {
            switch line {
            case let str where str.hasPrefix("Name:"):
                name = str.replacingOccurrences(of: "Name:", with: "").trim()
                
            case "Ingredients:":
                currentSection = "ingredients"
                
            case "Nutritional Values:":
                currentSection = "nutrition"
                
            case "Allergens:":
                currentSection = "allergens"
                
            case "Instructions:":
                currentSection = "instructions"
                
            case let str where str.lowercased().contains("time:"):
                clock = extractNumber(from: str)
                
            case let str where str.lowercased().contains("calories:"):
                calories = extractNumber(from: str)
                
            case let str where str.contains("Protein:"):
                protein = extractNumber(from: str)
                
            case let str where str.contains("Carbohydrates:"):
                carbohydrates = extractNumber(from: str)
                
            case let str where str.contains("Fat:"):
                fat = extractNumber(from: str)
                
            case let str where str.hasPrefix("ImageURL:"):
                imageURL = str.replacingOccurrences(of: "ImageURL:", with: "").trim()
                
            case let str where str.hasPrefix("-"):
                let item = str.replacingOccurrences(of: "- ", with: "").trim()
                switch currentSection {
                case "ingredients":
                    ingredients.append(item)
                case "allergens":
                    if item.lowercased() != "not available" {
                        allergens.append(item)
                    }
                default:
                    break
                }
                
            default:
                if currentSection == "instructions" {
                    if instructions.isEmpty {
                        instructions = line
                    } else {
                        instructions += "\n" + line
                    }
                }
            }
        }
        
        guard !name.isEmpty else { return nil }
        
        if allergens.isEmpty {
            allergens = ["No allergens found."]
        }
        
        return Recipe(
            name: name,
            ingredients: ingredients,
            calories: calories,
            protein: protein,
            carbohydrates: carbohydrates,
            fat: fat,
            allergens: allergens,
            instructions: instructions.trim(),
            imageURL: imageURL,
            clock: clock
        )
    }
    
    private func extractNumber(from text: String) -> Int {
        let numberPattern = #"\d+"#
        if let match = text.range(of: numberPattern, options: .regularExpression) {
            return Int(text[match]) ?? 0
        }
        return 0
    }
}

private extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespaces)
    }
}
