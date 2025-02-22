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
            self.error = "User not logged in"
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
                    print("❌ Firestore read error: \(error.localizedDescription)")
                    self.error = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("❌ Failed to fetch data from Firestore")
                    self.error = "Failed to fetch data"
                    return
                }
                
                do {
                    self.favoriteRecipes = try documents.compactMap { document in
                        var recipe = try document.data(as: Recipe.self)
                        recipe.id = document.documentID // Use Document ID as recipe ID
                        recipe.firestoreDocumentId = document.documentID
                        print("📌 Loaded recipe - ID: \(recipe.id), Name: \(recipe.name)")
                        return recipe
                    }
                    print("✅ A total of \(self.favoriteRecipes.count) recipes loaded")
                } catch {
                    print("❌ Data conversion error: \(error.localizedDescription)")
                    self.error = "Error occurred during data conversion"
                }
            }
    }

    func toggleFavorite(recipe: Recipe) {
        guard let userId = currentUser?.uid else {
            self.error = "You must log in to add to favorites"
            return
        }
        
        print("🔄 Toggle operation started - Recipe ID: \(recipe.id), Name: \(recipe.name)")
        
        let recipeRef = db.collection("users")
            .document(userId)
            .collection("favorites")
            .document(recipe.id)
        
        // First, check if the document exists
        recipeRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Favorite check error: \(error.localizedDescription)")
                self.error = "Error occurred while checking favorite status"
                return
            }
            
            if let document = document, document.exists {
                // If document exists (i.e., it's in favorites) - Delete
                print("🗑️ Recipe found in favorites, deleting...")
                recipeRef.delete { [weak self] error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("❌ Deletion error: \(error.localizedDescription)")
                        self.error = "Error occurred while deleting recipe from favorites"
                    } else {
                        print("✅ Recipe successfully deleted - ID: \(recipe.id)")
                        DispatchQueue.main.async {
                            // Remove from local array as well
                            self.favoriteRecipes.removeAll { $0.id == recipe.id }
                        }
                    }
                }
            } else {
                // If document doesn't exist (i.e., not in favorites) - Add
                print("➕ Recipe not found in favorites, adding...")
                var recipeToSave = recipe
                recipeToSave.firestoreDocumentId = recipe.id
                
                do {
                    try recipeRef.setData(from: recipeToSave)
                    print("✅ Recipe successfully added - ID: \(recipe.id)")
                } catch {
                    print("❌ Addition error: \(error.localizedDescription)")
                    self.error = "Error occurred while adding recipe to favorites"
                }
            }
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        guard let userId = currentUser?.uid else {
            print("❌ User is not logged in")
            self.error = "User is not logged in"
            return
        }

        for index in offsets {
            guard index < favoriteRecipes.count else {
                print("❌ Invalid index: \(index)")
                continue
            }

            let recipe = favoriteRecipes[index]
            let documentId = recipe.id
            
            print("🗑️ Deletion operation started - ID: \(documentId)")

            let recipeRef = db.collection("users")
                .document(userId)
                .collection("favorites")
                .document(documentId)

            recipeRef.delete { [weak self] error in
                if let error = error {
                    print("❌ Deletion error: \(error.localizedDescription)")
                    self?.error = "Error occurred while deleting recipe"
                } else {
                    print("✅ Recipe successfully deleted - ID: \(documentId)")
                    DispatchQueue.main.async {
                        self?.favoriteRecipes.removeAll { $0.id == documentId }
                    }
                }
            }
        }
    }
    
    func isFavorite(recipe: Recipe) -> Bool {
        let isFav = favoriteRecipes.contains { $0.id == recipe.id }
        print("🔍 Favorite check - Recipe ID: \(recipe.id), Is it a favorite?: \(isFav)")
        return isFav
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}
