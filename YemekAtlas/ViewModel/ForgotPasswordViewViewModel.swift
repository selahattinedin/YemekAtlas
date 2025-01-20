//
//  ForgotPasswordViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.01.2025.
//


import Foundation
import FirebaseAuth

class ForgotPasswordViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var errorMessage = ""
    @Published var successMessage = ""

    func resetPassword(completion: @escaping (Bool) -> Void) {
        // Debug: Email kontrolü yapalım
        print("E-posta kontrol ediliyor: \(email)")
        
        guard !email.isEmpty else {
            errorMessage = "E-posta adresinizi girin."
            print("Hata: E-posta boş")
            completion(false)
            return
        }
        
        // Firebase üzerinden şifre sıfırlama işlemi başlatma
        print("Şifre sıfırlama işlemi başlatılıyor...")
        
        // Firebase'in şifre sıfırlama işlemi başlatması
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Firebase hata mesajı
                self.errorMessage = "Bir hata oluştu: \(error.localizedDescription)"
                print("Firebase Hata: \(error.localizedDescription)")
                print("Hata Tipi: \(type(of: error))")
                completion(false)
                return
            }
            
            // Başarı mesajı
            self.successMessage = "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi."
            print("Başarılı: Şifre sıfırlama bağlantısı gönderildi.")
            completion(true)
        }
    }
    
    // Debug: E-posta geçerliliğini kontrol etme
    func validateEmail() -> Bool {
        print("E-posta doğrulaması yapılıyor: \(email)")
        
        // E-posta formatının doğru olduğundan emin olalım
        let emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailTest.evaluate(with: email)
        
        if isValid {
            print("E-posta formatı geçerli: \(email)")
        } else {
            print("Geçersiz e-posta formatı: \(email)")
        }
        
        return isValid
    }
    
    // Debug: Firebase kimlik doğrulama durumu
    func checkFirebaseAuthStatus() {
        print("Firebase kimlik doğrulama durumu kontrol ediliyor...")
        if let currentUser = Auth.auth().currentUser {
            print("Giriş yapan kullanıcı: \(currentUser.email ?? "Bilinmeyen")")
        } else {
            print("Kullanıcı giriş yapmamış.")
        }
    }
}
