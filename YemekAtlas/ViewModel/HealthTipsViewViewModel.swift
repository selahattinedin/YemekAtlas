//
//  HealthTipsViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 1.12.2024.
//

import Foundation
import GoogleGenerativeAI

class HealthTipsViewModel: ObservableObject {
    @Published var healthTips: [HealthTip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let generativeModel: GenerativeModel
    
    init() {
        generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    }
    
    @MainActor
    func fetchHealthTips() async {
        isLoading = true
        errorMessage = nil
        healthTips = []
        
        do {
            let prompt = """
            Bana 5 adet sağlıklı beslenme ve yaşam tarzı ipucu ver. Aşağıdaki formatta ver:

            İpucu 1:
            - Tip: [İpucu metni]
            - Kategori: [Beslenme/Egzersiz/Uyku/Su Tüketimi/Genel Sağlık]
            - Icon: [heart.fill/leaf.fill/bed.double.fill/drop.fill/star.fill]

            İpucu 2:
            ...
            (5 ipucu için aynı format)

            Lütfen ipuçları kısa, öz ve Türkçe olsun.
            """
            
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                healthTips = parseHealthTips(text)
            }
        } catch {
            errorMessage = "Sağlık ipuçları alınamadı: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func parseHealthTips(_ text: String) -> [HealthTip] {
        var tips: [HealthTip] = []
        var currentTip: (text: String, category: String, icon: String) = ("", "", "heart.fill")
        
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            if trimmedLine.hasPrefix("- Tip:") {
                currentTip.text = trimmedLine.replacingOccurrences(of: "- Tip:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmedLine.hasPrefix("- Kategori:") {
                currentTip.category = trimmedLine.replacingOccurrences(of: "- Kategori:", with: "").trimmingCharacters(in: .whitespaces)
            } else if trimmedLine.hasPrefix("- Icon:") {
                currentTip.icon = trimmedLine.replacingOccurrences(of: "- Icon:", with: "").trimmingCharacters(in: .whitespaces)
                
               
                if !currentTip.text.isEmpty {
                    tips.append(HealthTip(tip: currentTip.text,
                                        category: currentTip.category,
                                        icon: currentTip.icon))
                    currentTip = ("", "", "heart.fill") 
                }
            }
        }
        
        return tips
    }
}


