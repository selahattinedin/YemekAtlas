import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedOut = false
    @Published var isAnonymous = false
    
    private let db = Firestore.firestore()
    private var stateListener: AuthStateDidChangeListenerHandle?
    
    static let shared = AuthViewViewModel()
    
    init() {
        setupAuthStateListener()
    }
    
    func setupAuthStateListener() {
        stateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                
                if let user = user {
                    self?.isAnonymous = user.isAnonymous
                    
                    if user.isAnonymous {
                        self?.saveAnonymousUserToFirestore(uid: user.uid)
                    }
                } else {
                    self?.signInAnonymously()
                }
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print("🔥 Anonim giriş hatası: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.saveAnonymousUserToFirestore(uid: user.uid)
        }
    }
    
    private func saveAnonymousUserToFirestore(uid: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.setData([
            "createdAt": Date().timeIntervalSince1970,
            "isAnonymous": true
        ], merge: true) { error in
            if let error = error {
                print("🔥 Firestore anonim kullanıcı kaydı hatası: \(error.localizedDescription)")
            } else {
                print("✅ Anonim kullanıcı Firestore'a kaydedildi.")
            }
        }
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("User session not found")
            self.errorMessage = "User session not found"
            completion(false)
            return
        }

        let userId = currentUser.uid
        
        deleteUserData(userId: userId) { success in
            if !success {
                self.errorMessage = "Kullanıcı verileri silinemedi"
                completion(false)
                return
            }
            
            self.deleteAuthUser(user: currentUser) { success in
                if success {
                    DispatchQueue.main.async {
                        self.isLoggedOut = true
                        // Let AppState know account was deleted
                        AppState.shared.signOut()
                        completion(true)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    
    private func deleteUserData(userId: String, completion: @escaping (Bool) -> Void) {
        let userRef = db.collection("users").document(userId)
        
        deleteAllSubcollections(userId: userId) { success in
            guard success else {
                print("Alt koleksiyonlar silinemedi")
                completion(false)
                return
            }

            userRef.delete { error in
                if let error = error {
                    print("Firestore kullanıcı silme hatası: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Kullanıcı belgesi başarıyla silindi")
                    completion(true)
                }
            }
        }
    }
    
    private func deleteAuthUser(user: FirebaseAuth.User, completion: @escaping (Bool) -> Void) {
        user.delete { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print("Authentication hesap silme hatası: \(error.localizedDescription)")
                self.errorMessage = "Kullanıcı hesabı silinemedi: \(error.localizedDescription)"
                try? Auth.auth().signOut()
                completion(false)
                return
            }
            
            DispatchQueue.main.async {
                self.isLoggedOut = true
                completion(true)
            }
        }
    }
   
    func deleteAllSubcollections(userId: String, completion: @escaping (Bool) -> Void) {
        let userRef = db.collection("users").document(userId)

        userRef.collection("favorites").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Alt koleksiyonlar okunamadı: \(error.localizedDescription)")
                completion(false)
                return
            }

            let batch = self.db.batch()

            querySnapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }

            batch.commit { error in
                if let error = error {
                    print("Alt koleksiyonlar silinemedi: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Tüm alt koleksiyonlar silindi")
                    completion(true)
                }
            }
        }
    }
}
