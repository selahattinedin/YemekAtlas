import Foundation
import SwiftUI
import GoogleGenerativeAI
import Combine

class FoodGameViewViewModel: ObservableObject {
    
    private var generativeModel: GenerativeModel
    @Published var foodList: [Food] = []
    @Published var currentChampion: Food?
    @Published var currentChallenger: Food?
    @Published var finalWinner: Food?
    @Published var matchingComplete = false
    @Published var selectedCountry: Country?
    @Published var showCountryPicker = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showIntroView = true

    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
        
     
        NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))
            .sink { [weak self] _ in
               
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func selectCountry(_ country: Country) {
        self.selectedCountry = country
        self.showCountryPicker = false
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            await generateFoodsForCountry(country.name)
        }
    }
    
    @MainActor
    func generateFoodsForCountry(_ countryName: String) async {
        do {
         
            let promptFormat = NSLocalizedString("AI Prompt Format", comment: "")
            let prompt = String(format: promptFormat, countryName)
            
            let response = try await generativeModel.generateContent(prompt)
            
            if let responseText = response.text {
                print("AI Response: \(responseText)")
                
                let cleanedResponse = cleanJsonResponse(responseText)
              
                if let jsonData = cleanedResponse.data(using: .utf8),
                   let foodArray = try? JSONDecoder().decode([FoodDTOLocalized].self, from: jsonData) {
                    
                    self.foodList = foodArray.map { dto in
                        Food(name: dto.name,
                             image: "default_food_bg",
                             descriptionEN: dto.descriptionEN,
                             descriptionTR: dto.descriptionTR)
                    }
                    
                    if !self.foodList.isEmpty {
                        self.startGame()
                    } else {
                        self.errorMessage = LocaleManager.shared.localizedString(forKey: "No Dishes Generated Error")
                    }
                }
              
                else if let jsonData = cleanedResponse.data(using: .utf8),
                   let foodArray = try? JSONDecoder().decode([FoodDTO].self, from: jsonData) {
                    
                    self.foodList = foodArray.map { dto in
                        Food(name: dto.name,
                             image: "default_food_bg",
                             description: dto.description)
                    }
                    
                    if !self.foodList.isEmpty {
                        self.startGame()
                    } else {
                        self.errorMessage = LocaleManager.shared.localizedString(forKey: "No Dishes Generated Error")
                    }
                } else {
                    self.errorMessage = LocaleManager.shared.localizedString(forKey: "Parse Error")
                }
            } else {
                self.errorMessage = LocaleManager.shared.localizedString(forKey: "No Response Error")
            }
            
            self.isLoading = false
            
        } catch {
            self.errorMessage = String(format: LocaleManager.shared.localizedString(forKey: "API Error Format"), error.localizedDescription)
            self.isLoading = false
        }
    }

    private func cleanJsonResponse(_ response: String) -> String {
        var cleanedResponse = response
        
        if let startRange = cleanedResponse.range(of: "```json"),
           let endRange = cleanedResponse.range(of: "```", range: startRange.upperBound..<cleanedResponse.endIndex) {
            let startIndex = startRange.upperBound
            let endIndex = endRange.lowerBound
            cleanedResponse = String(cleanedResponse[startIndex..<endIndex])
        } else if let startRange = cleanedResponse.range(of: "```"),
                  let endRange = cleanedResponse.range(of: "```", range: startRange.upperBound..<cleanedResponse.endIndex) {
            let startIndex = startRange.upperBound
            let endIndex = endRange.lowerBound
            cleanedResponse = String(cleanedResponse[startIndex..<endIndex])
        }
        
        cleanedResponse = cleanedResponse.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return cleanedResponse
    }
    
    struct FoodDTO: Codable {
        let name: String
        let description: String
    }
    
    // İki dilde açıklamaları destekleyen yeni DTO
    struct FoodDTOLocalized: Codable {
        let name: String
        let descriptionEN: String
        let descriptionTR: String
    }
    
    func startGame() {
        foodList.shuffle()
        if foodList.count >= 2 {
            currentChampion = foodList.removeFirst()
            currentChallenger = foodList.removeFirst()
        }
    }

    func selectWinner(_ winner: Food) {
        currentChampion = winner
        if !foodList.isEmpty {
            currentChallenger = foodList.removeFirst()
        } else {
            finalWinner = winner
            matchingComplete = true
        }
    }

    func resetGame() {
        currentChampion = nil
        currentChallenger = nil
        finalWinner = nil
        matchingComplete = false
        showCountryPicker = true
        foodList = []
    }
    
    func restartGameWithSameCountry() {
        currentChampion = nil
        currentChallenger = nil
        finalWinner = nil
        matchingComplete = false
        isLoading = true
        errorMessage = nil
        
        if let country = selectedCountry {
            Task {
                await generateFoodsForCountry(country.name)
            }
        }
    }
    
    func tryAgainWithSameCountry() {
        if let country = selectedCountry {
            isLoading = true
            errorMessage = nil
            
            Task {
                await generateFoodsForCountry(country.name)
            }
        }
    }
}
