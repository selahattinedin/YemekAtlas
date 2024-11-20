//
//  SearchViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import Foundation
import GoogleGenerativeAI
import SwiftUI



    
class SearchViewViewModel: ObservableObject{

        @Published var searchText = ""
        @Published var recipe: Recipe?
        @Published var isLoading = false
        @Published var errorMessage: String?
        private let generativeModel: GenerativeModel

        init() {
            let apiKey = APIKey.default
            print(apiKey)
            generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)


                }
            
        

        @MainActor
        func fetchRecipe() async {
            guard !searchText.isEmpty else { return }
            
            isLoading = true
            errorMessage = nil
            recipe = nil
            
            let prompt = """
                '\(searchText)' tarifi için detaylı bilgi ver:
                İsim:
                Malzemeler:
                Kalori:
                Alerjenler:
                Yapılış:
                """
            
            let promt2 = "Write a story about a magic backpack."
            
            do {
                let response = try await generativeModel.generateContent(promt2)
                if let text = response.text {
                    print(text)
                    recipe = parseRecipeText(text)
                }
            } catch {
                errorMessage = "Hata: \(error.localizedDescription)"
            }
            
            isLoading = false
        }

        private func parseRecipeText(_ text: String) -> Recipe {
            let lines = text.components(separatedBy: .newlines)
            var currentSection = ""
            var name = ""
            var ingredients: [String] = []
            var calories = 0
            var allergens: [String] = []
            var instructions = ""
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)
                
                if trimmedLine.hasPrefix("İsim:") {
                    name = trimmedLine.replacingOccurrences(of: "İsim:", with: "").trimmingCharacters(in: .whitespaces)
                }
                else if trimmedLine == "Malzemeler:" {
                    currentSection = "malzemeler"
                }
                else if trimmedLine == "Alerjenler:" {
                    currentSection = "alerjenler"
                }
                else if trimmedLine.hasPrefix("Kalori:") {
                    let caloryString = trimmedLine.replacingOccurrences(of: "Kalori:", with: "")
                        .replacingOccurrences(of: "kcal", with: "")
                        .trimmingCharacters(in: .whitespaces)
                    calories = Int(caloryString) ?? 0
                }
                else if trimmedLine.hasPrefix("Yapılış:") {
                    instructions = trimmedLine.replacingOccurrences(of: "Yapılış:", with: "").trimmingCharacters(in: .whitespaces)
                }
                else if trimmedLine.hasPrefix("-") {
                    let item = trimmedLine.replacingOccurrences(of: "- ", with: "")
                    if currentSection == "malzemeler" {
                        ingredients.append(item)
                    } else if currentSection == "alerjenler" {
                        allergens.append(item)
                    }
                }
            }
            
            return Recipe(
                name: name.isEmpty ? searchText : name,
                ingredients: ingredients,
                calories: calories,
                allergens: allergens,
                instructions: instructions,
                imageURL: "https://example.com/food.jpg"
            )
        }
    }


    
    


