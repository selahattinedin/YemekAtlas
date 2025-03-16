import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                
                if let user = user, user.isAnonymous {
                    self?.saveAnonymousUserToFirestore(uid: user.uid)
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
}
