import Foundation
import GoogleGenerativeAI
import Combine

class DailyRecipesViewViewModel: ObservableObject {
    @Published var dailyRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let generativeModel: GenerativeModel
    private var retryCount = 0
    private let maxRetries = 3
    private let localeManager = LocaleManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKey.default)
        
        localeManager.$locale
            .sink { [weak self] newLocale in
                print("Locale changed to: \(newLocale.identifier)")
                Task {
                    await self?.fetchDailyRecipes()
                }
            }
            .store(in: &cancellables)
            
        Task {
            await fetchDailyRecipes()
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    @MainActor
    func fetchDailyRecipes() async {
        isLoading = true
        errorMessage = nil
        dailyRecipes = []
        
       
        let languageCode = localeManager.locale.identifier.prefix(2) == "tr" ? "tr" : "en"
        
       
        print("Current language from LocaleManager: \(languageCode)")
        print("Current locale identifier: \(localeManager.locale.identifier)")
        
        
        let promptKey = languageCode == "tr" ? "daily_recipe_prompt_tr" : "daily_recipe_prompt_en"
        
       
        let prompt = localeManager.localizedString(forKey: promptKey)
        print("Generated Prompt: \(prompt)")
        
        do {
            let response = try await generativeModel.generateContent(prompt)
            if let text = response.text {
                print("AI RESPONSE:\n\(text)")
                
                let potentialRecipesData = parseRecipeDataFromText(text, language: languageCode)
                if let recipeData = potentialRecipesData.first {
                    print("PARSED DATA:")
                    print("Name: \(recipeData.name)")
                    print("Ingredients: \(recipeData.ingredients.joined(separator: ", "))")
                    print("Calories: \(recipeData.calories)")
                    print("Protein: \(recipeData.protein)")
                    print("Carbohydrates: \(recipeData.carbohydrates)")
                    print("Fat: \(recipeData.fat)")
                    print("Preparation time: \(recipeData.clock)")
                    print("Allergens: \(recipeData.allergens.joined(separator: ", "))")
                 
                    if !recipeData.name.isEmpty {
                        let recipe = createRecipeWithDefaults(from: recipeData, language: languageCode)
                        dailyRecipes = [recipe]
                        retryCount = 0
                    } else {
                        if retryCount < maxRetries {
                            retryCount += 1
                            errorMessage = localeManager.localizedString(
                                forKey: languageCode == "tr" ? "loading_recipe_retry_tr" : "loading_recipe_retry_en"
                            )
                            await fetchDailyRecipes()
                            return
                        } else {
                            errorMessage = localeManager.localizedString(
                                forKey: languageCode == "tr" ? "recipe_data_error_tr" : "recipe_data_error_en"
                            )
                        }
                    }
                } else {
                    if retryCount < maxRetries {
                        retryCount += 1
                        errorMessage = localeManager.localizedString(
                            forKey: languageCode == "tr" ? "loading_recipe_retry_tr" : "loading_recipe_retry_en"
                        )
                        await fetchDailyRecipes()
                        return
                    } else {
                        errorMessage = localeManager.localizedString(
                            forKey: languageCode == "tr" ? "recipe_data_error_tr" : "recipe_data_error_en"
                        )
                    }
                }
            } else {
                errorMessage = localeManager.localizedString(
                    forKey: languageCode == "tr" ? "api_no_response_tr" : "api_no_response_en"
                )
            }
        } catch {
            errorMessage = localeManager.localizedStringWithFormat(
                forKey: languageCode == "tr" ? "api_error_tr" : "api_error_en",
                error.localizedDescription
            )
        }
        
        isLoading = false
    }
    
    private struct RecipeData {
        var name: String = ""
        var ingredients: [String] = []
        var calories: Int = 0
        var protein: Int = 0
        var carbohydrates: Int = 0
        var fat: Int = 0
        var allergens: [String] = []
        var instructions: String = ""
        var imageURL: String = "https://example.com/yemek-resmi.jpg"
        var clock: Int = 0
    }
    
    private func createRecipeWithDefaults(from data: RecipeData, language: String) -> Recipe {
        let defaultName = localeManager.localizedString(
            forKey: language == "tr" ? "default_recipe_name_tr" : "default_recipe_name_en"
        )
        
        let defaultIngredients = language == "tr" ?
            ["Un - 2 su bardağı", "Şeker - 1 su bardağı", "Yağ - 100g"] :
            ["Flour - 2 cups", "Sugar - 1 cup", "Butter - 100g"]
        
        let defaultAllergens = [localeManager.localizedString(
            forKey: language == "tr" ? "no_allergens_tr" : "no_allergens_en"
        )]
        
        let defaultInstructions = language == "tr" ?
            "1. Tüm malzemeleri karıştırın.\n2. 180°C fırında 30 dakika pişirin." :
            "1. Mix all ingredients.\n2. Bake in an oven at 180°C for 30 minutes."
        
        return Recipe(
            name: data.name.isEmpty ? defaultName : data.name,
            ingredients: data.ingredients.isEmpty ? defaultIngredients : data.ingredients,
            calories: data.calories > 0 ? data.calories : 350,
            protein: data.protein > 0 ? data.protein : 10,
            carbohydrates: data.carbohydrates > 0 ? data.carbohydrates : 45,
            fat: data.fat > 0 ? data.fat : 15,
            allergens: data.allergens.isEmpty ? defaultAllergens : data.allergens,
            instructions: data.instructions.isEmpty ? defaultInstructions : data.instructions,
            imageURL: data.imageURL.isEmpty ? "https://example.com/yemek-resmi.jpg" : data.imageURL,
            clock: data.clock > 0 ? data.clock : 30
        )
    }
    
    private func parseRecipeDataFromText(_ text: String, language: String) -> [RecipeData] {
        var recipeData = RecipeData()
        var currentSection = ""
        
     
        let nameKeys = language == "tr" ? ["İsim:", "Ad:", "Adı:", "Name:"] : ["Name:"]
        let ingredientsKeys = language == "tr" ? ["Malzemeler:", "Ingredients:"] : ["Ingredients:"]
        let nutritionKeys = language == "tr" ? ["Besin", "Beslenme", "Nutritional"] : ["Nutritional"]
        let allergensKeys = language == "tr" ? ["Alerjenler:", "Allergens:"] : ["Allergens:"]
        let instructionsKeys = language == "tr" ? ["Hazırlanışı:", "Yapılışı:", "Talimatlar:", "Instructions:"] : ["Instructions:"]
        let timeKeys = language == "tr" ? ["Süre:", "Hazırlama Süresi:", "Time:", "Preparation Time:"] : ["Time:", "Preparation Time:"]
        let caloriesKeys = language == "tr" ? ["Kalori:", "Calories:"] : ["Calories:"]
        let proteinKeys = language == "tr" ? ["Protein:"] : ["Protein:"]
        let carbsKeys = language == "tr" ? ["Karbonhidrat:", "Carbohydrates:"] : ["Carbohydrates:"]
        let fatKeys = language == "tr" ? ["Yağ:", "Fat:"] : ["Fat:"]
        let imageKeys = language == "tr" ? ["Resim:", "ResimURL:", "Görsel:", "ImageURL:"] : ["ImageURL:"]
        let notAvailableText = language == "tr" ? ["mevcut değil", "bulunamadı", "yok"] : ["not available", "none"]
        
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        print("--- First lines of response ---")
        for i in 0..<min(10, lines.count) {
            print("Line \(i): \(lines[i])")
        }
        
      
        for line in lines {
           
            if line.contains("**Name:**") || line.contains("**İsim:**") || line.contains("**Adı:**") {
                let cleanedLine = line.replacingOccurrences(of: "**Name:**", with: "")
                                     .replacingOccurrences(of: "**İsim:**", with: "")
                                     .replacingOccurrences(of: "**Adı:**", with: "")
                                     .trim()
                print("Found name in bold format: \(cleanedLine)")
                recipeData.name = cleanedLine
            }
            
           
            if line.contains("**ImageURL:**") || line.contains("**ResimURL:**") {
                let urlLine = line.replacingOccurrences(of: "**ImageURL:**", with: "")
                                 .replacingOccurrences(of: "**ResimURL:**", with: "")
                                 .trim()
                print("Found image URL in bold format: \(urlLine)")
                recipeData.imageURL = urlLine
            }
        }
        
      
        for line in lines {
          
            if line.contains("**Preparation Time:**") || line.contains("**Hazırlama Süresi:**") {
                recipeData.clock = extractNumber(from: line)
            } else if line.contains("Preparation Time:") || line.contains("Hazırlama Süresi:") {
                recipeData.clock = extractNumber(from: line)
            } else if (line.contains("Time:") || line.contains("Süre:")) && !line.contains("Serving") && !line.contains("Porsiyon") {
                recipeData.clock = extractNumber(from: line)
            }
            
        
            if containsAnyPrefix(line, prefixes: nameKeys) {
                let extractedName = removeAnyPrefix(line, prefixes: nameKeys).trim()
                print("Found name with prefix: \(extractedName)")
                recipeData.name = extractedName
            } else if containsAnyPrefix(line, prefixes: ingredientsKeys) || line.contains("**Ingredients:**") || line.contains("**Malzemeler:**") {
                currentSection = "ingredients"
                continue
            } else if containsAny(line, substrings: nutritionKeys) {
                currentSection = "nutrition"
            } else if containsAnyPrefix(line, prefixes: allergensKeys) || line.contains("**Allergens:**") || line.contains("**Alerjenler:**") {
                currentSection = "allergens"
                continue
            } else if containsAnyPrefix(line, prefixes: instructionsKeys) || line.contains("**Instructions:**") || line.contains("**Talimatlar:**") || line.contains("**Hazırlanışı:**") {
                currentSection = "instructions"
                let extractedInstructions = removeAnyPrefix(line, prefixes: instructionsKeys).trim()
                if !extractedInstructions.isEmpty {
                    recipeData.instructions = extractedInstructions
                }
            } else if containsAny(line, substrings: caloriesKeys) || line.contains("**Calories:**") || line.contains("**Kalori:**") {
                recipeData.calories = extractNumber(from: line)
            } else if line.contains("**Protein:**") {
                recipeData.protein = extractNumber(from: line)
            } else if line.contains("**Carbohydrates:**") || line.contains("**Karbonhidrat:**") {
                recipeData.carbohydrates = extractNumber(from: line)
            } else if line.contains("**Fat:**") || line.contains("**Yağ:**") {
                recipeData.fat = extractNumber(from: line)
            } else if containsAnyPrefix(line, prefixes: imageKeys) {
                let url = removeAnyPrefix(line, prefixes: imageKeys).trim()
                print("Found image URL with prefix: \(url)")
                recipeData.imageURL = !url.isEmpty ? url : "https://example.com/yemek-resmi.jpg"
            } else if line.hasPrefix("-") || line.hasPrefix("•") || (line.contains(":") && currentSection == "ingredients") {
                let item = line.replacingOccurrences(of: "- ", with: "")
                                .replacingOccurrences(of: "• ", with: "")
                                .trim()
                
                if currentSection == "ingredients" {
                    recipeData.ingredients.append(item)
                } else if currentSection == "allergens" {
                    if !containsAny(item.lowercased(), substrings: notAvailableText) {
                        recipeData.allergens.append(item)
                    }
                }
            } else if (line.first?.isNumber ?? false) && currentSection == "ingredients" {
               
                var ingredientText = line
                if let dotIndex = line.firstIndex(of: "."), dotIndex < line.endIndex {
                    let startIndex = line.index(after: dotIndex)
                    ingredientText = String(line[startIndex...]).trim()
                    recipeData.ingredients.append(ingredientText)
                } else {
                    recipeData.ingredients.append(line)
                }
            } else if line.first?.isNumber ?? false && line.contains(".") && currentSection == "instructions" {
                var instructionText = line
                if let dotIndex = line.firstIndex(of: "."), dotIndex < line.endIndex {
                    let startIndex = line.index(after: dotIndex)
                    instructionText = String(line[startIndex...]).trim()
                }
                
                if recipeData.instructions.isEmpty {
                    recipeData.instructions = instructionText
                } else {
                    recipeData.instructions += "\n" + instructionText
                }
            } else {
                if currentSection == "instructions" && !line.isEmpty {
                    if recipeData.instructions.isEmpty {
                        recipeData.instructions = line
                    } else {
                        recipeData.instructions += "\n" + line
                    }
                }
            }
        }
        
        
        let instructionsStartMarker = language == "tr" ? "**Hazırlanışı:**" : "**Instructions:**"
        let instructionsEndMarker = language == "tr" ? "**Servis Önerileri:**" : "**Serving Suggestions:**"
        
        let fullText = lines.joined(separator: "\n")
        if let startRange = fullText.range(of: instructionsStartMarker),
           let endRange = fullText.range(of: instructionsEndMarker, options: [], range: startRange.upperBound..<fullText.endIndex) {
           
            let instructionsBlockRange = startRange.upperBound..<endRange.lowerBound
            let instructionsBlock = fullText[instructionsBlockRange].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !instructionsBlock.isEmpty && (recipeData.instructions.isEmpty || instructionsBlock.count > recipeData.instructions.count) {
                print("Found instructions block: \(instructionsBlock.prefix(30))...")
                recipeData.instructions = instructionsBlock
            }
        }
        
       
        if recipeData.ingredients.isEmpty {
           
            for line in lines {
                if (line.contains(":") && line.contains("g")) ||
                   (line.contains(":") && line.contains("tablespoon")) ||
                   (line.contains(":") && line.contains("teaspoon")) ||
                   (line.contains(":") && line.contains("cup")) ||
                   (line.contains(":") && line.contains("yemek kaşığı")) ||
                   (line.contains(":") && line.contains("çay kaşığı")) ||
                   (line.contains(":") && line.contains("su bardağı")) {
                    let ingredient = line.trim()
                    recipeData.ingredients.append(ingredient)
                }
            }
        }
        
        if recipeData.allergens.isEmpty {
            let noAllergensText = language == "tr" ? "Alerjen bilgisi mevcut değil" : "No allergens information available"
            recipeData.allergens = [noAllergensText]
        }
        
       
        if recipeData.name.isEmpty {
           
            for line in lines.prefix(5) where !line.isEmpty {
                
                if !line.contains(":") &&
                   !line.contains("**") &&
                   !line.contains("Recipe") &&
                   !line.contains("Tarif") {
                    print("Using first line as name: \(line)")
                    recipeData.name = line
                    break
                }
            }
            

            if recipeData.name.isEmpty {
                recipeData.name = language == "tr" ? "Günün Tarifi" : "Recipe of the Day"
            }
        }
        
     
        print("--- Parsed Recipe Data ---")
        print("Name: \(recipeData.name)")
        print("Ingredients count: \(recipeData.ingredients.count)")
        print("Instructions length: \(recipeData.instructions.count) chars")
        print("Image URL: \(recipeData.imageURL)")
        
        return [recipeData]
    }
    
    private func containsAnyPrefix(_ string: String, prefixes: [String]) -> Bool {
        return prefixes.contains { string.hasPrefix($0) }
    }
    
    private func containsAny(_ string: String, substrings: [String]) -> Bool {
        return substrings.contains { string.contains($0) }
    }
    
    private func removeAnyPrefix(_ string: String, prefixes: [String]) -> String {
        for prefix in prefixes {
            if string.hasPrefix(prefix) {
                return string.replacingOccurrences(of: prefix, with: "")
            }
        }
        return string
    }
    
    private func extractNumber(from text: String) -> Int {
        print("Extracting number from: \(text)")
        
        if let regex = try? NSRegularExpression(pattern: "(\\d+)\\s*(?:minutes|mins|min|dakika|dk)", options: [.caseInsensitive]) {
            let nsString = text as NSString
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            
            if let match = matches.first {
                let numberRange = match.range(at: 1)
                if numberRange.location != NSNotFound {
                    let numberString = nsString.substring(with: numberRange)
                    if let number = Int(numberString) {
                        print("Found number with unit: \(number)")
                        return number
                    }
                }
            }
        }
        
       
        if let regex = try? NSRegularExpression(pattern: "(\\d+)", options: []) {
            let nsString = text as NSString
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            
            if let match = matches.first {
                let numberRange = match.range(at: 1)
                if numberRange.location != NSNotFound {
                    let numberString = nsString.substring(with: numberRange)
                    if let number = Int(numberString) {
                        print("Found raw number: \(number)")
                        return number
                    }
                }
            }
        }
        
    
        let digits = CharacterSet.decimalDigits
        var number = ""
        
        for char in text {
            if digits.contains(UnicodeScalar(String(char))!) {
                number.append(char)
            } else if !number.isEmpty {
                break
            }
        }
        
        let result = Int(number) ?? 0
        print("Fallback number extraction result: \(result)")
        return result
    }
}

private extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension CharacterSet {
    func contains(_ unicode: UnicodeScalar?) -> Bool {
        guard let unicode = unicode else { return false }
        return self.contains(unicode)
    }
}
