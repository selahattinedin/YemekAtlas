import Foundation
import GoogleGenerativeAI
import SwiftUI
import Combine

class SearchViewViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var recipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var popularRecipes: [Recipe] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let generativeModel: GenerativeModel
    private let localeManager = LocaleManager.shared

    init() {
        generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
        
        localeManager.$locale
            .sink { [weak self] newLocale in
                print("Locale changed to: \(newLocale.identifier)")
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }

    @MainActor
    func fetchRecipe() async {
        guard !searchText.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        recipe = nil

        
        let languageCode = localeManager.locale.identifier.prefix(2) == "tr" ? "tr" : "en"
        
       
        print("Current language from LocaleManager: \(languageCode)")
        print("Current locale identifier: \(localeManager.locale.identifier)")
        
        let promptKey = languageCode == "tr" ? "recipe_prompt_tr" : "recipe_prompt_en"
        
        
        let prompt = localeManager.localizedStringWithFormat(forKey: promptKey, searchText)
        print("Generated Prompt: \(prompt)")

        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                print("API Response: \(text)")
                recipe = parseRecipeText(text, language: languageCode)
            } else {
                errorMessage = localeManager.localizedString(
                    forKey: languageCode == "tr" ? "api_no_text_tr" : "api_no_text_en"
                )
            }
        } catch {
            errorMessage = localeManager.localizedStringWithFormat(
                forKey: languageCode == "tr" ? "api_error_tr" : "api_error_en",
                error.localizedDescription
            )
            print("API Error: \(error.localizedDescription)")
        }

        isLoading = false
    }

    private func parseRecipeText(_ text: String, language: String) -> Recipe {
        
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

        
        let nameKeys = language == "tr" ? ["Ad:"] : ["Name:"]
        let ingredientKeys = language == "tr" ? ["Malzemeler:"] : ["Ingredients:"]
        let allergenKeys = language == "tr" ? ["Alerjenler:"] : ["Allergens:"]
        let prepTimeKeys = language == "tr" ? ["Hazırlama Süresi:"] : ["Preparation Time:"]
        let calorieKeys = language == "tr" ? ["Kalori:"] : ["Calories:"]
        let proteinKeys = language == "tr" ? ["Protein:"] : ["Protein:"]
        let carbKeys = language == "tr" ? ["Karbonhidrat:"] : ["Carbohydrates:"]
        let fatKeys = language == "tr" ? ["Yağ:"] : ["Fat:"]
        let instructionKeys = language == "tr" ? ["Talimatlar:"] : ["Instructions:"]
        let imageURLKeys = language == "tr" ? ["ResimURL:"] : ["ImageURL:"]
        let notAvailableText = language == "tr" ? "Bulunamadı" : "Not available"

        let lines = text.components(separatedBy: .newlines)

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
           
            if nameKeys.contains(where: { trimmedLine.hasPrefix($0) }) {
                let key = nameKeys.first(where: { trimmedLine.hasPrefix($0) })!
                name = trimmedLine.replacingOccurrences(of: key, with: "").trim()
            }
            else if ingredientKeys.contains(where: { trimmedLine == $0 }) {
                currentSection = "ingredients"
            }
            else if allergenKeys.contains(where: { trimmedLine == $0 }) {
                currentSection = "allergens"
            }
            else if prepTimeKeys.contains(where: { trimmedLine.contains($0) }) {
                clock = extractNumber(from: trimmedLine)
            }
            else if calorieKeys.contains(where: { trimmedLine.lowercased().contains($0.lowercased()) }) {
                calories = extractNumber(from: trimmedLine)
            }
            else if proteinKeys.contains(where: { trimmedLine.contains($0) }) {
                protein = extractNumber(from: trimmedLine)
            }
            else if carbKeys.contains(where: { trimmedLine.contains($0) }) {
                carbohydrates = extractNumber(from: trimmedLine)
            }
            else if fatKeys.contains(where: { trimmedLine.contains($0) }) {
                fat = extractNumber(from: trimmedLine)
            }
            else if instructionKeys.contains(where: { trimmedLine.hasPrefix($0) }) {
                currentSection = "instructions"
                let key = instructionKeys.first(where: { trimmedLine.hasPrefix($0) })!
                instructions = trimmedLine.replacingOccurrences(of: key, with: "").trim()
            }
            else if imageURLKeys.contains(where: { trimmedLine.hasPrefix($0) }) {
                let key = imageURLKeys.first(where: { trimmedLine.hasPrefix($0) })!
                imageURL = trimmedLine.replacingOccurrences(of: key, with: "").trim()
            }
            else if trimmedLine.hasPrefix("-") {
                let item = trimmedLine.replacingOccurrences(of: "- ", with: "").trim()
                if currentSection == "ingredients" {
                    ingredients.append(item)
                } else if currentSection == "allergens" && item != notAvailableText {
                    allergens.append(item)
                }
            }
            else if currentSection == "instructions" && !trimmedLine.isEmpty {
                instructions += (instructions.isEmpty ? "" : "\n") + trimmedLine.trim()
            }
        }

      
        if name.isEmpty {
            name = searchText
        }
        
       
        let noAllergensText = language == "tr" ? "Alerjen bulunamadı" : "No allergens found"
        if allergens.isEmpty {
            allergens = [noAllergensText]
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
        let numberPattern = "\\d+"
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
