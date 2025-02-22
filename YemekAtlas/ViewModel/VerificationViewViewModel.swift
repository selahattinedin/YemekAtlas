import Foundation
import FirebaseAuth

class VerificationViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var verificationStatus = "Email verification is pending..."
    @Published var isVerified = false
    @Published var shouldNavigateToLogin = false
    
    private var verificationTimer: Timer?
    
    func startVerificationCheck() {
        verificationTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.checkVerificationStatus()
        }
    }
    
    func checkVerificationStatus() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not found"
            return
        }
        
        user.reload { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            DispatchQueue.main.async {
                if user.isEmailVerified {
                    self?.verificationStatus = "Email verified!"
                    self?.verificationTimer?.invalidate()
                    
                    // Log out and navigate to login after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.signOut()
                        self?.shouldNavigateToLogin = true
                    }
                } else {
                    self?.verificationStatus = "Email not verified yet.\nPlease check your inbox."
                }
            }
        }
    }
    
    func resendVerificationEmail() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not found"
            return
        }
        
        user.sendEmailVerification { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Unable to send email: \(error.localizedDescription)"
                } else {
                    self?.verificationStatus = "A new verification email has been sent!"
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "Unable to sign out: \(error.localizedDescription)"
        }
    }
    
    deinit {
        verificationTimer?.invalidate()
    }
}
