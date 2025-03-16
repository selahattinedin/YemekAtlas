import Foundation
import FirebaseFirestore
import FirebaseAuth

class FavoriteRecipesManager: ObservableObject {
    @Published var favoriteRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
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

    func toggleFavorite(recipe: Recipe) {
        guard let user = Auth.auth().currentUser else {
            self.error = "Favori eklemek için giriş yapmalısınız."
            return
        }
        
        let recipeRef = db.collection("users")
            .document(user.uid)
            .collection("favorites")
            .document(recipe.id)
        
        // Önce tarifin favorilerde olup olmadığını kontrol et
        recipeRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Favori kontrol hatası: \(error.localizedDescription)")
                self.error = "Favori kontrol edilirken hata oluştu."
                return
            }
            
            if let document = document, document.exists {
                // Tarif zaten favorilerdeyse, kaldır
                print("🗑️ Tarif favorilerde bulundu, siliniyor...")
                recipeRef.delete { error in
                    if let error = error {
                        print("❌ Silme hatası: \(error.localizedDescription)")
                        self.error = "Favori silinirken hata oluştu."
                    } else {
                        print("✅ Tarif favorilerden kaldırıldı: \(recipe.name)")
                        DispatchQueue.main.async {
                            self.favoriteRecipes.removeAll { $0.id == recipe.id }
                        }
                    }
                }
            } else {
                // Tarif favorilerde değilse, ekle
                print("➕ Tarif favorilerde bulunamadı, ekleniyor...")
                var recipeToSave = recipe
                recipeToSave.firestoreDocumentId = recipe.id
                
                do {
                    try recipeRef.setData(from: recipeToSave)
                    print("✅ Tarif başarıyla favorilere eklendi: \(recipe.name)")
                } catch {
                    print("❌ Ekleme hatası: \(error.localizedDescription)")
                    self.error = "Tarif favorilere eklenirken hata oluştu."
                }
            }
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
    
    func isFavorite(recipe: Recipe) -> Bool {
        let isFav = favoriteRecipes.contains { $0.id == recipe.id }
        print("🔍 Favori kontrol - Tarif ID: \(recipe.id), Favori mi?: \(isFav)")
        return isFav
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}
