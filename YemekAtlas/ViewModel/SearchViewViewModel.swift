//
//  SearchViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import Foundation
import GoogleGenerativeAI
import SwiftUI

class SearchViewViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var recipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var popularRecipes: [Recipe] = []

    private let generativeModel: GenerativeModel

    init() {
        generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    }

    @MainActor
    func fetchRecipe() async {
        guard !searchText.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        recipe = nil

        let prompt = """
        Provide the recipe for '\(searchText)' in the format below for only one recipe. Be sure to check and mention important allergens:

        Name: [Recipe name]

        Ingredients:
        (List the ingredients for a single recipe with a - before each item)
        - [Ingredient and quantity]

        Calories: Provide a suitable calorie count for the recipe. [Only number] kcal

        Nutritional Values:
        Protein: [Only number] g
        Carbohydrates: [Only number] g
        Fat: [Only number] g

        Preparation Time: [Only number] minutes

        Allergens:
        [CHECK EACH INGREDIENT AND LIST BELOW:
        - If the ingredients contain gluten, shellfish, eggs, dairy, fish, mustard, peanuts, black pepper, or soy, list them under the "Allergen:" heading.
        - Only mention allergenic ingredients under the Allergen heading, and if none are found, write "Not available."]
        
        Instructions:
        [Detailed recipe]

        ImageURL: [URL for dish image]
        """


        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                recipe = parseRecipeText(text)
            }
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func parseRecipeText(_ text: String) -> Recipe {
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

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)

            switch trimmedLine {
            case let str where str.hasPrefix("Name:"):
                name = str.replacingOccurrences(of: "Name:", with: "").trim()

            case "Ingredients:":
                currentSection = "ingredients"

            case "Allergens:":
                currentSection = "allergens"

            case let str where str.contains("Preparation Time:"):
                clock = extractNumber(from: str)

            case let str where str.lowercased().contains("calories"):
                calories = extractNumber(from: str)

            case let str where str.contains("Protein:"):
                protein = extractNumber(from: str)

            case let str where str.contains("Carbohydrates:"):
                carbohydrates = extractNumber(from: str)

            case let str where str.contains("Fat:"):
                fat = extractNumber(from: str)

            case let str where str.hasPrefix("Instructions:"):
                currentSection = "instructions"
                instructions = str.replacingOccurrences(of: "Instructions:", with: "").trim()

            case let str where str.hasPrefix("ImageURL:"):
                imageURL = str.replacingOccurrences(of: "ImageURL:", with: "").trim()

            case let str where str.hasPrefix("-"):
                let item = str.replacingOccurrences(of: "- ", with: "").trim()
                if currentSection == "ingredients" {
                    ingredients.append(item)
                } else if currentSection == "allergens" && item != "Not available" {
                    allergens.append(item)
                }

            case let str where currentSection == "instructions" && !str.isEmpty:
                instructions += (instructions.isEmpty ? "" : "\n") + str.trim()

            default:
                break
            }
        }

        return Recipe(
            name: name.isEmpty ? searchText : name,
            ingredients: ingredients,
            calories: calories,
            protein: protein,
            carbohydrates: carbohydrates,
            fat: fat,
            allergens: allergens.isEmpty ? ["No allergens found"] : allergens,
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
