import Foundation
import FirebaseAuth

class VerificationViewViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var verificationStatus = "E-posta doğrulaması bekleniyor..."
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
            errorMessage = "Kullanıcı bulunamadı"
            return
        }
        
        user.reload { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Hata: \(error.localizedDescription)"
                }
                return
            }
            
            DispatchQueue.main.async {
                if user.isEmailVerified {
                    self?.verificationStatus = "E-posta doğrulandı!"
                    self?.verificationTimer?.invalidate()
                    
                    // Kısa bir gecikme ile çıkış yapıp login'e yönlendir
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.signOut()
                        self?.shouldNavigateToLogin = true
                    }
                } else {
                    self?.verificationStatus = "E-posta henüz doğrulanmadı.\nLütfen mail kutunuzu kontrol edin."
                }
            }
        }
    }
    
    func resendVerificationEmail() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "Kullanıcı bulunamadı"
            return
        }
        
        user.sendEmailVerification { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Mail gönderilemedi: \(error.localizedDescription)"
                } else {
                    self?.verificationStatus = "Yeni doğrulama maili gönderildi!"
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "Çıkış yapılamadı: \(error.localizedDescription)"
        }
    }
    
    deinit {
        verificationTimer?.invalidate()
    }
}
