import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let user = result?.user else { return }
            
            self.db.collection("users").document(user.uid).setData([
                "lastLogin": Date().timeIntervalSince1970
            ], merge: true) { error in
                if let error = error {
                    print("🔥 Failed to update last login time: \(error.localizedDescription)")
                } else {
                    print("✅ Last login time updated successfully.")
                }
            }
        }
    }
    
    func validate() -> Bool {
        errorMessage = ""
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        
        guard email.contains("@") && email.contains(".com") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        return true
    }
}
