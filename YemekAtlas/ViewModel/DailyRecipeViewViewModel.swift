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
            
            Kalori:  Tarif Adına en uygun Kalori [Sadece sayı] kcal
            
            Alerjenler:
            
            [MALZEMELERİ TEK TEK KONTROL ET VE AŞAĞIDA LİSTELE:
                - Eğer malzemelerde gluten, kabuklu deniz ürünleri, yumurta, süt ürünleri, balık, hardal, yer fıstığı,karabiber veya soya varsa "Alerjen:" başlığı altında yaz.
                - Sadece alerjen madde olanları Alerjen başlığı altında belirt listede hiçbiri yoksa o zaman "Bulunmuyor" yaz.
                - Gluten içeren tahıllar ve bunların ürünleri
                - Kabuklular (Crustacea) ve bunların ürünleri
                - Yumurta ve yumurta ürünleri
                - Süt ve süt ürünleri
                - Balık ve balık ürünleri
                - Hardal ve hardal ürünleri
                - Yer fıstığı ve yer fıstığı ürünleri
                - Soya fasulyesi ve soya fasulyesi ürünleri
                -Karabiber
            
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
                let numberPattern = "\\d+"
                if let match = str.range(of: numberPattern, options: .regularExpression) {
                    let numberStr = String(str[match])
                    calories = Int(numberStr) ?? 520
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
            name: name,
            ingredients: ingredients,
            calories: calories,
            allergens: allergens.isEmpty ? ["Alerjen bulunmuyor"] : allergens,
            instructions: instructions,
            imageURL: imageURL
        )
    }
}

private extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespaces)
    }
}
