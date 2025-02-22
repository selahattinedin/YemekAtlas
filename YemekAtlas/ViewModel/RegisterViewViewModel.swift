import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var agreeToTerms = false
    @Published var errorMessage = ""
    @Published var showVerificationScreen = false
    @Published var isRegistered = false
    
    private let db = Firestore.firestore()
    
    func register() {
        guard validate() else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
                return
            }
            
            guard let user = result?.user else {
                DispatchQueue.main.async {
                    self.errorMessage = "User could not be created."
                }
                return
            }
            
            // Add username to Firebase Authentication
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = self.name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("🔥 Failed to update username: \(error.localizedDescription)")
                } else {
                    print("✅ Username updated: \(self.name)")
                    
                    // Save user to Firestore
                    self.db.collection("users").document(user.uid).setData([
                        "name": self.name,
                        "email": self.email,
                        "joined": Date().timeIntervalSince1970
                    ]) { error in
                        if let error = error {
                            print("🔥 Firestore save error: \(error.localizedDescription)")
                        } else {
                            print("✅ User successfully saved to Firestore.")
                        }
                    }
                }
            }
            
            // Send verification email
            user.sendEmailVerification { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Verification email could not be sent: \(error.localizedDescription)"
                    } else {
                        print("✅ Verification email sent!")
                        self.isRegistered = true
                        self.showVerificationScreen = true
                    }
                }
            }
        }
    }
    
    func validate() -> Bool {
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        
        guard agreeToTerms else {
            errorMessage = "You must accept the terms and conditions."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }
        
        return true
    }
}
