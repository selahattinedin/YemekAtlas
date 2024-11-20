//
//  RecipeService.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 20.11.2024.
//

import Foundation

class RecipeService {
    static let baseUrl = "https://generativelanguage.googleapis.com/v1beta/{name=gemini-1.5-flash/*}"

    static let apiKey = APIKey.default

    static func fetchRecipe(for query: String) async throws -> Recipe {
        // URL'yi oluştur
        guard let url = URL(string: "\(baseUrl)?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            throw URLError(.badURL)
        }
        
        // İstek oluştur
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // İstek gönder ve yanıtı al
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Yanıt durumunu kontrol et
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // JSON'u ayrıştır ve modeli döndür
        do {
            let recipe = try JSONDecoder().decode(Recipe.self, from: data)
            return recipe
        } catch {
            throw error // JSON ayrıştırma hatası
        }
    }
}

