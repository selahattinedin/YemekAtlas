import Foundation
import FirebaseFirestore
import FirebaseAuth

class FavoriteRecipesManager: ObservableObject {
    @Published var favoriteRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    private var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if user != nil {
                self?.setupFavoritesListener()
            } else {
                self?.favoriteRecipes = []
                self?.listenerRegistration?.remove()
            }
        }
    }

    func loadFavoriteRecipes() {
        setupFavoritesListener()
    }

    func setupFavoritesListener() {
        guard let userId = currentUser?.uid else {
            self.error = "Kullanıcı oturum açmamış"
            return
        }
        
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
                    print("❌ Firestore'dan veri alınamadı")
                    self.error = "Veriler alınamadı"
                    return
                }
                
                do {
                    self.favoriteRecipes = try documents.compactMap { document in
                        var recipe = try document.data(as: Recipe.self)
                        recipe.id = document.documentID // Document ID'yi recipe ID'si olarak kullan
                        recipe.firestoreDocumentId = document.documentID
                        print("📌 Yüklenen tarif - ID: \(recipe.id), İsim: \(recipe.name)")
                        return recipe
                    }
                    print("✅ Toplam \(self.favoriteRecipes.count) tarif yüklendi")
                } catch {
                    print("❌ Veri dönüştürme hatası: \(error.localizedDescription)")
                    self.error = "Veriler dönüştürülürken hata oluştu"
                }
            }
    }

    func toggleFavorite(recipe: Recipe) {
        guard let userId = currentUser?.uid else {
            self.error = "Favorilere eklemek için giriş yapmalısınız"
            return
        }
        
        print("🔄 Toggle işlemi başlatıldı - Tarif ID: \(recipe.id), İsim: \(recipe.name)")
        
        let recipeRef = db.collection("users")
            .document(userId)
            .collection("favorites")
            .document(recipe.id)
        
        // Önce document'in var olup olmadığını kontrol et
        recipeRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Favori kontrolü hatası: \(error.localizedDescription)")
                self.error = "Favori durumu kontrol edilirken hata oluştu"
                return
            }
            
            if let document = document, document.exists {
                // Document varsa (yani favorilerdeyse) - Sil
                print("🗑️ Tarif favorilerde bulundu, siliniyor...")
                recipeRef.delete { [weak self] error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("❌ Silme hatası: \(error.localizedDescription)")
                        self.error = "Tarif favorilerden kaldırılırken hata oluştu"
                    } else {
                        print("✅ Tarif başarıyla silindi - ID: \(recipe.id)")
                        DispatchQueue.main.async {
                            // Local array'den de sil
                            self.favoriteRecipes.removeAll { $0.id == recipe.id }
                        }
                    }
                }
            } else {
                // Document yoksa (yani favorilerde değilse) - Ekle
                print("➕ Tarif favorilerde bulunamadı, ekleniyor...")
                var recipeToSave = recipe
                recipeToSave.firestoreDocumentId = recipe.id
                
                do {
                    try recipeRef.setData(from: recipeToSave)
                    print("✅ Tarif başarıyla eklendi - ID: \(recipe.id)")
                } catch {
                    print("❌ Ekleme hatası: \(error.localizedDescription)")
                    self.error = "Tarif favorilere eklenirken hata oluştu"
                }
            }
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        guard let userId = currentUser?.uid else {
            print("❌ Kullanıcı oturumu açık değil")
            self.error = "Kullanıcı oturumu açık değil"
            return
        }

        for index in offsets {
            guard index < favoriteRecipes.count else {
                print("❌ Geçersiz index: \(index)")
                continue
            }

            let recipe = favoriteRecipes[index]
            let documentId = recipe.id
            
            print("🗑️ Silme işlemi başlatıldı - ID: \(documentId)")

            let recipeRef = db.collection("users")
                .document(userId)
                .collection("favorites")
                .document(documentId)

            recipeRef.delete { [weak self] error in
                if let error = error {
                    print("❌ Silme hatası: \(error.localizedDescription)")
                    self?.error = "Tarif silinirken hata oluştu"
                } else {
                    print("✅ Tarif başarıyla silindi - ID: \(documentId)")
                    DispatchQueue.main.async {
                        self?.favoriteRecipes.removeAll { $0.id == documentId }
                    }
                }
            }
        }
    }
    
    func isFavorite(recipe: Recipe) -> Bool {
        let isFav = favoriteRecipes.contains { $0.id == recipe.id }
        print("🔍 Favori kontrolü - Tarif ID: \(recipe.id), Favori mi?: \(isFav)")
        return isFav
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}
