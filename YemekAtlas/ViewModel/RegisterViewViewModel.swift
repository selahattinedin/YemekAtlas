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
                    self.errorMessage = "Kayıt başarısız: \(error.localizedDescription)"
                }
                return
            }
            
            guard let user = result?.user else {
                DispatchQueue.main.async {
                    self.errorMessage = "Kullanıcı oluşturulamadı."
                }
                return
            }
            
            // Kullanıcı adı Firebase Authentication'a ekleniyor
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = self.name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("🔥 Kullanıcı adı güncellenemedi: \(error.localizedDescription)")
                } else {
                    print("✅ Kullanıcı adı güncellendi: \(self.name)")
                    
                    // Firestore'a kullanıcıyı kaydet
                    self.db.collection("users").document(user.uid).setData([
                        "name": self.name,
                        "email": self.email,
                        "joined": Date().timeIntervalSince1970
                    ]) { error in
                        if let error = error {
                            print("🔥 Firestore kayıt hatası: \(error.localizedDescription)")
                        } else {
                            print("✅ Kullanıcı Firestore'a başarıyla kaydedildi.")
                        }
                    }
                }
            }
            
            // Doğrulama maili gönder
            user.sendEmailVerification { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.errorMessage = "Doğrulama maili gönderilemedi: \(error.localizedDescription)"
                    } else {
                        print("✅ Doğrulama maili gönderildi!")
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
            errorMessage = "Lütfen tüm alanları doldurun."
            return false
        }
        
        guard agreeToTerms else {
            errorMessage = "Kullanım koşullarını kabul etmelisiniz."
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Geçerli bir e-posta adresi giriniz."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Şifre en az 6 karakter uzunluğunda olmalıdır."
            return false
        }
        
        return true
    }
}
