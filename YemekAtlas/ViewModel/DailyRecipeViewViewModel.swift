//
//  DailyRecipeViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 5.12.2024.
//

import Foundation
import GoogleGenerativeAI

class DailyRecipeViewViewModel: ObservableObject {
    
    @Published var dailyRecipe: Recipe?
    @Published var isLoading = false
    private let generativeModel: GenerativeModel
    
    init() {
        generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    }
    
    @MainActor
    func fetchDailyRecipe() async {
        isLoading = true
        dailyRecipe = nil
        
        do {
            let prompt = """
            Türk mutfağından günün yemeği için bir öneri ver ve aşağıdaki formatta bilgi ver:
            
            İsim: [Tarif adı]
            
            Malzemeler:
            (Malzemeleri listele ve başına - koy)
            - [Malzeme ve miktarı]
            
            Kalori: Tarif adına en uygun kalori [Sadece sayı] kcal
            
            Besin Değerleri:
            Protein: [Sadece sayı] g
            Karbonhidrat: [Sadece sayı] g
            Yağ: [Sadece sayı] g
            
            Alerjenler:
            [MALZEMELERİ TEK TEK KONTROL ET VE AŞAĞIDA LİSTELE:
                - Eğer malzemelerde gluten, kabuklu deniz ürünleri, yumurta, süt ürünleri, balık, hardal, yer fıstığı, karabiber veya soya varsa "Alerjen:" başlığı altında yaz.
                - Sadece alerjen madde olanları Alerjen başlığı altında belirt listede hiçbiri yoksa o zaman "Bulunmuyor" yaz.]

            Yapılış:
            [Detaylı tarif]
            
            ImageURL: [Yemek görseli için URL]
            """
            
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                dailyRecipe = parseRecipeText(text)
            }
        } catch {
            print("Error fetching recipe: \(error)")
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
                calories = extractNumber(from: str)
                
            case let str where str.contains("Protein:"):
                protein = extractNumber(from: str)
                
            case let str where str.contains("Karbonhidrat:"):
                carbohydrates = extractNumber(from: str)
                
            case let str where str.contains("Yağ:"):
                fat = extractNumber(from: str)
                
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
            name: name,
            ingredients: ingredients,
            calories: calories,
            protein: protein,
            carbohydrates: carbohydrates,
            fat: fat,
            allergens: allergens.isEmpty ? ["Alerjen bulunmuyor"] : allergens,
            instructions: instructions,
            imageURL: imageURL
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
