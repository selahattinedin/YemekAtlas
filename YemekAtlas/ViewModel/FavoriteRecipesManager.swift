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
        try? db.clearPersistence()
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
                
                self.favoriteRecipes = documents.compactMap { document in
                    print("📌 Firestore'daki Tarif ID: \(document.documentID)")
                    var recipe = try? document.data(as: Recipe.self)
                    recipe?.firestoreDocumentId = document.documentID
                    return recipe
                }.sorted {
                    $0.firestoreDocumentId ?? "" > $1.firestoreDocumentId ?? ""
                }
            }
    }

    
    func toggleFavorite(recipe: Recipe) {
        guard let userId = currentUser?.uid else {
            self.error = "Favorilere eklemek için giriş yapmalısınız"
            return
        }
        
        let recipeRef = db.collection("users")
            .document(userId)
            .collection("favorites")
            .document(recipe.id.uuidString)
        
        if !isFavorite(recipe: recipe) {
            do {
                try recipeRef.setData(from: recipe)
            } catch {
                self.error = "Tarif favorilere eklenirken hata oluştu: \(error.localizedDescription)"
            }
        } else {
            recipeRef.delete { error in
                if let error = error {
                    self.error = "Tarif favorilerden kaldırılırken hata oluştu: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        guard let userId = currentUser?.uid else {
            print("Hata: Kullanıcı oturumu açık değil.")
            self.error = "Kullanıcı oturumu açık değil."
            return
        }

        for index in offsets {
            guard index < favoriteRecipes.count else {
                print("Hata: Geçersiz index!")
                return
            }

            let recipe = favoriteRecipes[index]
            
            guard let documentId = recipe.firestoreDocumentId else {
                print("Hata: Firestore document ID'si bulunamadı")
                return
            }

            let recipeRef = db.collection("users")
                .document(userId)
                .collection("favorites")
                .document(documentId)

            print("Firestore'dan silme işlemi başlatılıyor: \(documentId)")

            // Firestore'dan silme işlemi
            recipeRef.delete { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Firestore silme hatası: \(error.localizedDescription)")
                        self?.error = "Tarif silinirken hata oluştu: \(error.localizedDescription)"
                    } else {
                        print("Firestore'dan başarıyla silindi: \(documentId)")
                        
                        // Favori tarifi silme işlemi başarılı, veriyi tekrar yükle
                        self?.setupFavoritesListener()
                    }
                }
            }
        }
    }




    
    func isFavorite(recipe: Recipe) -> Bool {
        return favoriteRecipes.contains(where: { $0.id == recipe.id })
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}
