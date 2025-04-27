import Foundation
import SwiftUI
import GoogleGenerativeAI

// Define a struct for Country
struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let flag: String
    
    static let popularCountries = [
        Country(name: "Türkiye", flag: "🇹🇷"),
        Country(name: "Italy", flag: "🇮🇹"),
        Country(name: "Japan", flag: "🇯🇵"),
        Country(name: "Mexico", flag: "🇲🇽"),
        Country(name: "India", flag: "🇮🇳"),
        Country(name: "France", flag: "🇫🇷"),
        Country(name: "China", flag: "🇨🇳"),
        Country(name: "Greece", flag: "🇬🇷"),
        Country(name: "Thailand", flag: "🇹🇭"),
        Country(name: "USA", flag: "🇺🇸")
    ]
}


class FoodGameViewViewModel: ObservableObject {
    // The AI model
    private var generativeModel: GenerativeModel
    
    // Game state
    @Published var foodList: [Food] = []
    @Published var currentChampion: Food?
    @Published var currentChallenger: Food?
    @Published var finalWinner: Food?
    @Published var matchingComplete = false
    
    // Country selection
    @Published var selectedCountry: Country?
    @Published var showCountryPicker = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // Initialize the Gemini model
        self.generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
    }
    
    // Select a country and generate foods
    func selectCountry(_ country: Country) {
        self.selectedCountry = country
        self.showCountryPicker = false
        self.isLoading = true
        self.errorMessage = nil
        
        // Generate foods for the selected country
        Task {
            await generateFoodsForCountry(country.name)
        }
    }
    
    // Generate foods using Gemini AI
    @MainActor
    func generateFoodsForCountry(_ countryName: String) async {
        do {
            // Create AI prompt text with localization
            let promptFormat = String(localized: "AI Prompt Format")
            let prompt = String(format: promptFormat, countryName)
            
            // Get response from AI
            let response = try await generativeModel.generateContent(prompt)
            
            if let responseText = response.text {
                // Parse the JSON response
                print("AI Response: \(responseText)") // For debugging
                
                // Clean the JSON response
                let cleanedResponse = cleanJsonResponse(responseText)
                
                if let jsonData = cleanedResponse.data(using: .utf8),
                   let foodArray = try? JSONDecoder().decode([FoodDTO].self, from: jsonData) {
                    
                    // Convert DTOs to Food objects
                    self.foodList = foodArray.map { dto in
                        Food(name: dto.name,
                             image: "default_food_bg", // Default image for now
                             description: dto.description)
                    }
                    
                    // Start the game
                    if !self.foodList.isEmpty {
                        self.startGame()
                    } else {
                        self.errorMessage = "No dishes could be generated. Please try again."
                    }
                } else {
                    self.errorMessage = "Could not parse AI response. Please try again."
                }
            } else {
                self.errorMessage = "No response received from AI. Please try again."
            }
            
            self.isLoading = false
            
        } catch {
            self.errorMessage = "Error: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    // Helper function to extract clean JSON from AI response
    private func cleanJsonResponse(_ response: String) -> String {
        // Clean markdown code blocks
        var cleanedResponse = response
        
        // Remove ```json and ``` markers
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
        
        // Clean whitespace at beginning and end
        cleanedResponse = cleanedResponse.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return cleanedResponse
    }
    
    // Structure to decode JSON from AI response
    struct FoodDTO: Codable {
        let name: String
        let description: String
    }
    
    // Game functions
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
