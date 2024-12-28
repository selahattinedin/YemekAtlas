//
//  GunlukYemekViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.12.2024.
//

import Foundation
import GoogleGenerativeAI
import SwiftUI

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
        Bana Türk ve dünya mutfağından 4 rastgele yemek tarifi ver. Her tarif şu formatta olmalı:

        İsim: [Tarif adı]

        Malzemeler: 
        (Tarif için malzemeleri listele ve başına - koy)
        - [Malzeme ve miktarı]

        Kalori: Tarif adına uygun bir kalori ver. [Sadece sayı] kcal

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
        
        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                dailyRecipes = parseMultipleRecipesText(text)
            }
        } catch {
            errorMessage = "Günlük tarifler yüklenirken hata oluştu: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func parseMultipleRecipesText(_ text: String) -> [Recipe] {
        let recipeBlocks = text.components(separatedBy: "\n\n\n")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        let recipes = recipeBlocks.compactMap { parseRecipeText($0) }
        return Array(recipes.prefix(4))
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
        var imageURL = "https://via.placeholder.com/150"
        var currentSection = ""
        
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        for line in lines {
            switch line {
            case let str where str.hasPrefix("İsim:"):
                name = str.replacingOccurrences(of: "İsim:", with: "").trim()
                
            case "Malzemeler:":
                currentSection = "malzemeler"
                
            case "Besin Değerleri:":
                currentSection = "besin"
                
            case "Alerjenler:":
                currentSection = "alerjenler"
                
            case "Yapılış:":
                currentSection = "yapilis"
                
            case let str where str.lowercased().contains("kalori:"):
                calories = extractNumber(from: str)
                
            case let str where str.contains("Protein:"):
                protein = extractNumber(from: str)
                
            case let str where str.contains("Karbonhidrat:"):
                carbohydrates = extractNumber(from: str)
                
            case let str where str.contains("Yağ:"):
                fat = extractNumber(from: str)
                
            case let str where str.hasPrefix("ImageURL:"):
                imageURL = str.replacingOccurrences(of: "ImageURL:", with: "").trim()
                
            case let str where str.hasPrefix("-"):
                let item = str.replacingOccurrences(of: "- ", with: "").trim()
                switch currentSection {
                case "malzemeler":
                    ingredients.append(item)
                case "alerjenler":
                    if item.lowercased() != "bulunmuyor" {
                        allergens.append(item)
                    }
                default:
                    break
                }
                
            default:
                if currentSection == "yapilis" {
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
            allergens = ["Alerjen bulunmuyor"]
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
            imageURL: imageURL
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
