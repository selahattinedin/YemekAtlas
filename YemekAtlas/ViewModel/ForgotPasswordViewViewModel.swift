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
        // Firebase üzerinden e-posta ile şifre sıfırlama bağlantısı gönderme
        guard !email.isEmpty else {
            errorMessage = "E-posta adresinizi girin."
            completion(false)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = "Bir hata oluştu: \(error.localizedDescription)"
                completion(false)
                return
            }
            
            self.successMessage = "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi."
            completion(true)
        }
    }
}
