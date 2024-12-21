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
        '\(searchText)' tarifi için sadece tek bir tarif olacak şekilde aşağıdaki formatta bilgi ver. Önemli alerjenleri özellikle kontrol et ve belirt:

        İsim: [Tarif adı]

        Malzemeler: 
        (Tek tarif için malzemeleri listele ve başına - koy)
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
        var protein = 0
        var carbohydrates = 0
        var fat = 0
        var allergens: [String] = []
        var instructions = ""
        var imageURL = "https:en.wikipedia.org/wiki/Adana_kebab%C4%B1#/media/File:Adana_kebab.jpg"
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
            name: name.isEmpty ? searchText : name,
            ingredients: ingredients,
            calories: calories,
            protein: protein,
            carbohydrates: carbohydrates,
            fat: fat,
            allergens: allergens.isEmpty ? ["Alerjen bulunmuyor"] : allergens,
            instructions: instructions.trim(),
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


    
    


