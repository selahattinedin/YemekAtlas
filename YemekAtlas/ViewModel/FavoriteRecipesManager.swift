import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class FavoriteRecipesManager: ObservableObject {
    @Published var favoriteRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteRecipes"
    private let imageCacheKey = "favoriteRecipeImages"
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let user = user {
                    print("✅ Kullanıcı oturum açtı: \(user.uid)")
                    self?.setupFavoritesListener(for: user.uid)
                } else {
                    print("❌ Kullanıcı oturumu kapattı, favoriler sıfırlandı.")
                    self?.favoriteRecipes = []
                    self?.listenerRegistration?.remove()
                }
            }
        }
        loadFavorites()
    }

    func loadFavoriteRecipes() {
        guard let user = Auth.auth().currentUser else { return }
        setupFavoritesListener(for: user.uid)
    }

    private func setupFavoritesListener(for userId: String) {
        isLoading = true
        listenerRegistration?.remove()
        
        listenerRegistration = db.collection("users")
            .document(userId)
            .collection("favorites")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    print("❌ Firestore okuma hatası: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("❌ Firestore verisi çekilemedi")
                    self.error = "Favoriler alınamadı"
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        self.favoriteRecipes = try documents.compactMap { document in
                            var recipe = try document.data(as: Recipe.self)
                            recipe.id = document.documentID
                            recipe.firestoreDocumentId = document.documentID
                            print("📌 Yüklenen tarif: \(recipe.name) - ID: \(recipe.id)")
                            return recipe
                        }
                        print("✅ Toplam \(self.favoriteRecipes.count) favori tarif yüklendi.")
                    } catch {
                        print("❌ Data dönüştürme hatası: \(error.localizedDescription)")
                        self.error = "Veri dönüşüm hatası"
                    }
                }
            }
    }

    func toggleFavorite(_ recipe: Recipe) {
        guard let user = Auth.auth().currentUser else {
            self.error = "Kullanıcı giriş yapmamış"
            return
        }

        if isFavorite(recipe) {
            // Favorilerden kaldır
            if let documentId = recipe.firestoreDocumentId {
                let recipeRef = db.collection("users")
                    .document(user.uid)
                    .collection("favorites")
                    .document(documentId)

                recipeRef.delete { [weak self] error in
                    if let error = error {
                        print("❌ Silme hatası: \(error.localizedDescription)")
                        self?.error = "Tarif silinirken hata oluştu."
                    } else {
                        print("✅ Tarif başarıyla favorilerden kaldırıldı")
                        DispatchQueue.main.async {
                            self?.favoriteRecipes.removeAll { $0.firestoreDocumentId == documentId }
                        }
                    }
                }
            }
        } else {
            // Favorilere ekle
            var recipeToSave = recipe
            let docRef = db.collection("users")
                .document(user.uid)
                .collection("favorites")
                .document()

            recipeToSave.id = docRef.documentID
            recipeToSave.firestoreDocumentId = docRef.documentID

            do {
                try docRef.setData(from: recipeToSave) { [weak self] error in
                    if let error = error {
                        print("❌ Ekleme hatası: \(error.localizedDescription)")
                        self?.error = "Tarif eklenirken hata oluştu."
                    } else {
                        print("✅ Tarif başarıyla favorilere eklendi")
                        DispatchQueue.main.async {
                            self?.favoriteRecipes.append(recipeToSave)
                        }
                    }
                }
            } catch {
                print("❌ Data dönüştürme hatası: \(error.localizedDescription)")
                self.error = "Veri dönüşüm hatası"
            }
        }
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        favoriteRecipes.contains { $0.name == recipe.name }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteRecipes) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            favoriteRecipes = decoded
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        guard let user = Auth.auth().currentUser else {
            self.error = "Kullanıcı giriş yapmamış"
            return
        }

        for index in offsets {
            guard index < favoriteRecipes.count else {
                print("❌ Geçersiz indeks: \(index)")
                continue
            }

            let recipe = favoriteRecipes[index]
            let documentId = recipe.id
            
            print("🗑️ Favoriden kaldırma işlemi başladı - ID: \(documentId)")

            let recipeRef = db.collection("users")
                .document(user.uid)
                .collection("favorites")
                .document(documentId)

            recipeRef.delete { [weak self] error in
                if let error = error {
                    print("❌ Silme hatası: \(error.localizedDescription)")
                    self?.error = "Tarif silinirken hata oluştu."
                } else {
                    print("✅ Tarif başarıyla favorilerden kaldırıldı: \(documentId)")
                    DispatchQueue.main.async {
                        self?.favoriteRecipes.removeAll { $0.id == documentId }
                    }
                }
            }
        }
    }
    
    // Görsel URL'lerini kaydet
    func saveImageURL(for recipeName: String, imageURL: String) {
        var imageCache = getImageCache()
        imageCache[recipeName] = imageURL
        userDefaults.set(imageCache, forKey: imageCacheKey)
    }
    
    // Görsel URL'sini getir
    func getImageURL(for recipeName: String) -> String? {
        let imageCache = getImageCache()
        return imageCache[recipeName]
    }
    
    // Cache'den tüm görsel URL'lerini getir
    private func getImageCache() -> [String: String] {
        return userDefaults.dictionary(forKey: imageCacheKey) as? [String: String] ?? [:]
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}
