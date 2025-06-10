//
//  RecipeDetailViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 2.03.2025.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class RecipeDetailViewModel: ObservableObject {
    @Published var selectedTab = "Ingredients"
    @Published var selectedIngredients: Set<String> = []
    @Published var isFavorite = false
    @Published var generatedImageURL: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let tabs = ["Ingredients", "Instructions", "Allergens"]
    private var favoritesManager = FavoriteRecipesManager()
    private var recipe: Recipe?
    
    // Resim URL'lerini saklamak için static dictionary
    private static var imageCache: [String: String] = [:]
    
    private var leonardoApiKey: String {
        guard let path = Bundle.main.path(forResource: "LeonardoAI-Info", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let apiKey = dict["Image_Api_Key"] as? String else {
            print("Error: Leonardo AI API key not found in LeonardoAI-Info.plist")
            return ""
        }
        return apiKey
    }
    
    func setRecipe(_ recipe: Recipe) {
        self.recipe = recipe
        self.isFavorite = favoritesManager.isFavorite(recipe)
        
        // Şefin spesyali için yapay zeka görsel üretimini atla
        if ["Pizza", "Sushi", "Hamburger", "Tacos", "PadThai"].contains(recipe.imageURL) {
            self.generatedImageURL = recipe.imageURL
            return
        }
        
        // Yükleniyor durumunu ayarla
        self.isLoading = true
        
        // 1. Tam eşleşme için Firestore'da ara
        let db = Firestore.firestore()
        db.collection("recipes").document(recipe.id).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            if let document = document, document.exists, 
               let imageURL = document.data()?["imageURL"] as? String, 
               !imageURL.isEmpty {
                // Tam eşleşme bulundu, kayıtlı görseli kullan
                print("Using exact match image URL from Firestore: \(imageURL)")
                DispatchQueue.main.async {
                    self.generatedImageURL = imageURL
                    self.isLoading = false
                }
                return
            }
            
            // 2. İsim bazlı arama yap (daha önce benzer tarifler aranmış mı?)
            self.searchFirestoreByName(recipe) { found in
                if found {
                    // Benzer tarif bulundu ve görsel atandı
                    return
                }
                
                // 3. Daha önce önbellekte saklanan görseli kontrol et
                if let cachedImageURL = RecipeDetailViewModel.imageCache[recipe.name] {
                    print("Using cached image URL: \(cachedImageURL)")
                    self.generatedImageURL = cachedImageURL
                    
                    // Önbellekteki URL'i Firestore'a da kaydet
                    db.collection("recipes").document(recipe.id).setData([
                        "id": recipe.id,
                        "name": recipe.name,
                        "imageURL": cachedImageURL,
                        "ingredients": recipe.ingredients,
                        "createdAt": FieldValue.serverTimestamp()
                    ], merge: true) { error in
                        if let error = error {
                            print("Error updating Firestore with cached URL: \(error.localizedDescription)")
                        } else {
                            print("Successfully updated Firestore with cached URL")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                
                // 4. Hiçbir kayıt bulunamadıysa yeni görsel oluştur
                self.generateImageForRecipe(recipe)
            }
        }
    }
    
    private func searchFirestoreByName(_ recipe: Recipe, completion: @escaping (Bool) -> Void) {
        // Yemek adını küçük harfe çevir ve boşlukları kaldır
        let normalizedName = recipe.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        let db = Firestore.firestore()
        
        // İsim bazlı arama
        db.collection("recipes")
            .whereField("name", isGreaterThanOrEqualTo: normalizedName)
            .whereField("name", isLessThanOrEqualTo: normalizedName + "\u{f8ff}")
            .limit(to: 5)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else {
                    completion(false)
                    return
                }
                
                if let error = error {
                    print("Error searching Firestore: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    // Benzer isimli tarif bulunamadı
                    print("No similar recipes found in Firestore")
                    completion(false)
                    return
                }
                
                // En yüksek benzerliğe sahip tarifi bul
                var bestMatch: [String: Any]? = nil
                var highestSimilarity: Double = 0.4 // Minimum benzerlik eşiği
                
                for document in documents {
                    let data = document.data()
                    if let docName = data["name"] as? String {
                        let similarity = self.calculateSimilarity(between: normalizedName, and: docName.lowercased())
                        if similarity > highestSimilarity {
                            highestSimilarity = similarity
                            bestMatch = data
                        }
                    }
                }
                
                if let bestMatch = bestMatch, let imageURL = bestMatch["imageURL"] as? String, !imageURL.isEmpty {
                    print("Found similar recipe with \(Int(highestSimilarity * 100))% match: \(bestMatch["name"] ?? "Unknown")")
                    print("Using similar recipe's image URL: \(imageURL)")
                    
                    DispatchQueue.main.async {
                        self.generatedImageURL = imageURL
                        self.isLoading = false
                        
                        // Önbelleğe ve Firestore'a kaydet
                        RecipeDetailViewModel.imageCache[recipe.name] = imageURL
                        
                        // Mevcut tarif için görsel URL'i güncelle
                        db.collection("recipes").document(recipe.id).setData([
                            "id": recipe.id,
                            "name": recipe.name,
                            "imageURL": imageURL,
                            "ingredients": recipe.ingredients,
                            "createdAt": FieldValue.serverTimestamp()
                        ], merge: true)
                    }
                    
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }
    
    private func calculateSimilarity(between str1: String, and str2: String) -> Double {
        guard !str1.isEmpty && !str2.isEmpty else { return 0.0 }
        
        // Levenshtein mesafesini hesapla
        let distance = levenshteinDistance(between: str1, and: str2)
        let maxLength = max(str1.count, str2.count)
        
        // Benzerlik oranını hesapla (0.0 - 1.0 arası, 1.0 tam eşleşme)
        return 1.0 - (Double(distance) / Double(maxLength))
    }
    
    private func levenshteinDistance(between s1: String, and s2: String) -> Int {
        let s1 = Array(s1)
        let s2 = Array(s2)
        
        var dp = [[Int]](repeating: [Int](repeating: 0, count: s2.count + 1), count: s1.count + 1)
        
        for i in 0...s1.count {
            dp[i][0] = i
        }
        
        for j in 0...s2.count {
            dp[0][j] = j
        }
        
        for i in 1...s1.count {
            for j in 1...s2.count {
                if s1[i-1] == s2[j-1] {
                    dp[i][j] = dp[i-1][j-1]
                } else {
                    dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1
                }
            }
        }
        
        return dp[s1.count][s2.count]
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        favoritesManager.toggleFavorite(recipe)
        self.isFavorite = favoritesManager.isFavorite(recipe)
    }
    
    func generateImageForRecipe(_ recipe: Recipe) {
        // Eğer resim zaten oluşturulmuşsa tekrar oluşturma
        if RecipeDetailViewModel.imageCache[recipe.name] != nil {
            self.generatedImageURL = RecipeDetailViewModel.imageCache[recipe.name]
            return
        }
        
        guard !leonardoApiKey.isEmpty else {
            errorMessage = "Leonardo AI API key not found"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Leonardo AI API endpoint ve headers
        let apiUrl = "https://cloud.leonardo.ai/api/rest/v1/generations"
        
        // Yemek adından Türkçe karakterleri temizlemeyi kaldıralım, orijinal ismi kullanalım
        // Ama yine de prompt'u daha spesifik hale getirelim
        let prompt = """
        Professional food photography of "\(recipe.name)" (Turkish dish).
        High-quality, detailed image of the prepared dish on a plate.
        Appetizing presentation, vibrant colors, studio lighting.
        Focus on the food itself, no people, no text, minimal background.
        Traditional Turkish cuisine, realistic photo, not illustration.
        """
        
        // Request body
        let requestBody: [String: Any] = [
            "prompt": prompt,
            "modelId": "ac614f96-1082-45bf-be9d-757f2d31c174",
            "width": 1024,
            "height": 1024,
            "num_images": 1,
            "promptMagic": true,
            "promptMagicVersion": "v2",
            "contrastRatio": 0.5,
            "guidance_scale": 7,
            "highContrast": true,
            "presetStyle": "LEONARDO"
        ]
        
        guard let url = URL(string: apiUrl) else {
            isLoading = false
            errorMessage = "Invalid API URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(leonardoApiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            isLoading = false
            errorMessage = "Error creating request: \(error.localizedDescription)"
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("API Response:", json)
                        
                        if let error = json["error"] as? String {
                            self?.errorMessage = "API error: \(error)"
                            return
                        }
                        
                        if let generationId = json["sdGenerationJob"] as? [String: Any] {
                            if let id = generationId["generationId"] as? String {
                                self?.getGeneratedImage(generationId: id)
                            } else {
                                self?.errorMessage = "Generation ID not found in response"
                            }
                        } else {
                            self?.errorMessage = "Invalid response format"
                        }
                    }
                } catch {
                    self?.errorMessage = "Error parsing response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func getGeneratedImage(generationId: String) {
        isLoading = true
        errorMessage = nil
        
        let apiUrl = "https://cloud.leonardo.ai/api/rest/v1/generations/\(generationId)"
        
        guard let url = URL(string: apiUrl) else {
            isLoading = false
            errorMessage = "Invalid API URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(leonardoApiKey)", forHTTPHeaderField: "Authorization")
        
        func pollForImage() {
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.isLoading = false
                        self?.errorMessage = "Network error: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let data = data else {
                        self?.isLoading = false
                        self?.errorMessage = "No data received"
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            print("Image Response:", json)
                            
                            if let error = json["error"] as? String {
                                self?.errorMessage = "API error: \(error)"
                                return
                            }
                            
                            if let generations = json["generations_by_pk"] as? [String: Any] {
                                if let status = generations["status"] as? String {
                                    if status == "COMPLETE" {
                                        if let generatedImages = generations["generated_images"] as? [[String: Any]],
                                           let firstImage = generatedImages.first,
                                           let imageUrl = firstImage["url"] as? String {
                                            // Leonardo AI'dan gelen görseli Firebase Storage'a yükle
                                            // Storage sorunu varsa geçici olarak doğrudan Leonardo URL kullan
                                            self?.saveImageUrl(imageUrl: imageUrl)
                                            // TODO: Firebase Storage düzeltildikten sonra aşağıdaki satırı aktif et
                                            // self?.uploadImageToFirebaseStorage(leonardoImageUrl: imageUrl)
                                        } else {
                                            self?.errorMessage = "Image URL not found in response"
                                            self?.isLoading = false
                                        }
                                    } else if status == "PENDING" || status == "IN_PROGRESS" {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            pollForImage()
                                        }
                                    } else {
                                        self?.errorMessage = "Generation failed with status: \(status)"
                                        self?.isLoading = false
                                    }
                                } else {
                                    self?.errorMessage = "Status not found in response"
                                    self?.isLoading = false
                                }
                            } else {
                                self?.errorMessage = "Generation data not found in response"
                                self?.isLoading = false
                            }
                        }
                    } catch {
                        self?.errorMessage = "Error parsing response: \(error.localizedDescription)"
                        self?.isLoading = false
                    }
                }
            }.resume()
        }
        
        pollForImage()
    }
    
    private func uploadImageToFirebaseStorage(leonardoImageUrl: String) {
        print("Uploading image to Firebase Storage from Leonardo AI URL: \(leonardoImageUrl)")
        
        // Görseli Leonardo AI URL'inden indir
        guard let url = URL(string: leonardoImageUrl) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid Leonardo AI image URL"
                self.isLoading = false
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("Image download error: \(error)")
                    self.errorMessage = "Error downloading image: \(error.localizedDescription)"
                    self.isLoading = false
                }
                return
            }
            
            // HTTP response kontrol et
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "HTTP Error: \(httpResponse.statusCode)"
                        self.isLoading = false
                    }
                    return
                }
            }
            
            guard let imageData = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No image data received"
                    self.isLoading = false
                }
                return
            }
            
            print("Image data size: \(imageData.count) bytes")
            
            // Görselin geçerli olup olmadığını kontrol et
            guard UIImage(data: imageData) != nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid image data"
                    self.isLoading = false
                }
                return
            }
            
            DispatchQueue.main.async {
                // Firebase Storage referansı oluştur - Manuel bucket URL ile
                let storage = Storage.storage(url: "gs://yemekatlas-14b97.appspot.com")
                let storageRef = storage.reference()
                print("Storage bucket URL: \(storage.reference().bucket)")
                
                // Benzersiz dosya adı oluştur
                let fileName = "\(UUID().uuidString).jpg"
                let imageRef = storageRef.child("recipe-images/\(fileName)")
                
                print("Uploading to Firebase Storage path: recipe-images/\(fileName)")
                
                // Metadata oluştur
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                // Görseli Firebase Storage'a yükle
                let uploadTask = imageRef.putData(imageData, metadata: metadata) { [weak self] metadata, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Firebase Storage upload error: \(error)")
                        print("Error code: \((error as NSError).code)")
                        print("Error domain: \((error as NSError).domain)")
                        self.errorMessage = "Firebase Storage Error: \(error.localizedDescription)"
                        self.isLoading = false
                        return
                    }
                    
                    print("Upload successful, getting download URL...")
                    
                    // Yükleme başarılı, download URL'ini al
                    imageRef.downloadURL { [weak self] url, error in
                        guard let self = self else { return }
                        
                        if let error = error {
                            print("Download URL error: \(error)")
                            self.errorMessage = "Error getting download URL: \(error.localizedDescription)"
                            self.isLoading = false
                            return
                        }
                        
                        guard let downloadURL = url else {
                            self.errorMessage = "Download URL is nil"
                            self.isLoading = false
                            return
                        }
                        
                        print("Download URL obtained: \(downloadURL.absoluteString)")
                        
                        // Firebase Storage URL'ini kaydet
                        self.saveImageUrl(imageUrl: downloadURL.absoluteString)
                    }
                }
                
                // Upload progress izle
                uploadTask.observe(.progress) { snapshot in
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    print("Upload progress: \(percentComplete)%")
                }
                
                uploadTask.observe(.failure) { snapshot in
                    if let error = snapshot.error {
                        print("Upload failed with error: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    private func saveImageUrl(imageUrl: String) {
        // Firebase Storage URL'ini kullan
        print("Using Firebase Storage URL: \(imageUrl)")
        self.generatedImageURL = imageUrl
        
        // URL'i cache'e kaydet
        if let recipeName = self.recipe?.name {
            RecipeDetailViewModel.imageCache[recipeName] = imageUrl
        }
        
        // Authentication kontrolü
        guard Auth.auth().currentUser != nil else {
            print("User not authenticated, skipping Firestore update")
            self.isLoading = false
            return
        }
        
        // Firestore'a kaydet
        if let recipe = self.recipe {
            let db = Firestore.firestore()
            
            // Önce dökümanı kontrol et, yoksa oluştur
            let docRef = db.collection("recipes").document(recipe.id)
            docRef.getDocument { [weak self] document, error in
                if let document = document, document.exists {
                    // Döküman varsa update et
                    docRef.updateData([
                        "imageURL": imageUrl
                    ]) { [weak self] error in
                        DispatchQueue.main.async {
                            self?.handleFirestoreResult(error: error)
                        }
                    }
                } else {
                    // Döküman yoksa oluştur
                    docRef.setData([
                        "id": recipe.id,
                        "name": recipe.name,
                        "imageURL": imageUrl,
                        "createdAt": FieldValue.serverTimestamp()
                    ], merge: true) { [weak self] error in
                        DispatchQueue.main.async {
                            self?.handleFirestoreResult(error: error)
                        }
                    }
                }
            }
        } else {
            self.isLoading = false
        }
    }
    
    private func handleFirestoreResult(error: Error?) {
        if let error = error {
            print("Firestore update error: \(error.localizedDescription)")
            // Firestore hatası olsa bile görseli göster
            print("Warning: Could not save to Firestore, but image is still available")
        } else {
            print("Successfully updated Firestore document with image URL")
        }
        self.isLoading = false
    }
    
    func toggleIngredient(_ ingredient: String) {
        if selectedIngredients.contains(ingredient) {
            selectedIngredients.remove(ingredient)
        } else {
            selectedIngredients.insert(ingredient)
        }
    }
}
