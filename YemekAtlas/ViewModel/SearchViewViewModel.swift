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
            generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
            

        }
        
        @MainActor
        func fetchRecipe() async {
            guard !searchText.isEmpty else { return }
            
            isLoading = true
            errorMessage = nil
            recipe = nil
            
            do {
                let prompt = """
                '\(searchText)' tarifi için aşağıdaki formatı koruyarak bilgi ver ve en sonunda bir image url ver:
                
                İsim: [Tarif adı]
                
                Malzemeler:
                - [Her malzeme ve miktarı ayrı satırda]
                
                Kalori: kcal
                
                Alerjenler:
                (Sadece varsa yazılacak, yoksa "Bulunmuyor" yazılacak)
                
                Yapılış:
                [Adım adım talimatlar]
                
                ImageURL: [Yemek görseli için bir URL]
                
                bu adımlarda 3 tarif istiyorum
                """
                
                let response = try await generativeModel.generateContent(prompt)
                if let text = response.text {
                    recipe = parseRecipeText(text)
                }
            } catch {
                errorMessage = "Hata: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    
   
        
        private func parseRecipeText(_ text: String) -> Recipe {
            var name = ""
            var ingredients: [String] = []
            var calories = 0
            var allergens: [String] = []
            var instructions = ""
            var imageURL = "https:en.wikipedia.org/wiki/Adana_kebab%C4%B1#/media/File:Adana_kebab.jpg "
            var currentSection = ""
            
            let lines = text.components(separatedBy: .newlines)
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespaces)
                
                switch trimmedLine {
                case let str where str.hasPrefix("İsim:"):
                    name = str.replacingOccurrences(of: "İsim:", with: "").trim()
                    
                case "Malzemeler:":
                    currentSection = "malzemeler"
                    
                case "Alerjenler:":
                    currentSection = "alerjenler"
                    
                    case let str where str.lowercased().contains("kalori"):
                                let numberPattern = "\\d+"
                                if let match = str.range(of: numberPattern, options: .regularExpression) {
                                    let numberStr = String(str[match])
                                    calories = Int(numberStr) ?? 350 // Eğer parse edilemezse makul bir default değer
                                } else {
                                    // Kalori değeri bulunamazsa yaklaşık bir değer ata
                                    calories = 350
                                }
                    
                case let str where str.hasPrefix("Yapılış:"):
                    currentSection = "yapilis"
                    instructions = str.replacingOccurrences(of: "Yapılış:", with: "").trim()
                    
                case let str where str.hasPrefix("ImageURL:"):
                    imageURL = str.replacingOccurrences(of: "ImageURL:", with: "").trim()
                    
                case let str where str.hasPrefix("-"):
                    let item = str.replacingOccurrences(of: "- ", with: "").trim()
                    if currentSection == "malzemeler" {
                        ingredients.append(item)
                    } else if currentSection == "alerjenler" && item != "Bulunmuyor" {
                        allergens.append(item)
                    }
                    
                case let str where currentSection == "yapilis" && !str.isEmpty:
                    instructions += "\n" + str.trim()
                    
                default:
                    break
                }
            }
            
            return Recipe(
                name: name.isEmpty ? searchText : name,
                ingredients: ingredients,
                calories: calories,
                allergens: allergens.isEmpty ? ["Alerjen bulunmuyor"] : allergens,
                instructions: instructions.trim(),
                imageURL: imageURL
            )
        }
    }

    private extension String {
        func trim() -> String {
            self.trimmingCharacters(in: .whitespaces)
        }
    }


    
    


