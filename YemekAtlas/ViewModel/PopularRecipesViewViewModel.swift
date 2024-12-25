//
//  PopularRecipesViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.12.2024.
//

import Foundation
import Foundation
import GoogleGenerativeAI

@MainActor
class PopularRecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let generativeModel: GenerativeModel

    init() {
        generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    }

    func fetchPopularRecipes() async {
        isLoading = true
        errorMessage = nil

        let prompt = """
        Bana 4 adet popüler tarif ver ve formatı şu şekilde olsun:

        İsim: [Tarif adı]

        Malzemeler:
        (Malzemeler için liste başına - koy)
        - [Malzeme]

        Kalori: [Sayı] kcal
        Besin Değerleri:
        Protein: [Sayı] g
        Karbonhidrat: [Sayı] g
        Yağ: [Sayı] g

        Alerjenler: [Liste veya 'Bulunmuyor']
        Yapılış: [Detaylı tarif]
        ImageURL: [Görsel URL]
        """

        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                recipes = parseRecipesText(text)
            }
        } catch {
            errorMessage = "Hata: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func parseRecipesText(_ text: String) -> [Recipe] {
        // API cevabını parçalayıp tarifleri `Recipe` objesine dönüştür.
        // Her tarifi ayır ve `Recipe` array olarak döndür.
        // Bu kısmı yukarıdaki `parseRecipeText` metodu gibi yazabiliriz.
        return []
    }
}

