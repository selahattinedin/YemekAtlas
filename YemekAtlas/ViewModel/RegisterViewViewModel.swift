//
//  RegisterViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 22.10.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var agreeToTerms = false
    @Published var errorMessage = ""
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid else {
                return
            }
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Lütfen tüm alanları doldurunuz."
            return false
        }
        
        guard email.contains("@") && email.contains(".com") else {
            errorMessage = "Lütfen geçerli bir email adresi girininiz."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Lütfen 6 veya daha fazla karakterli bir şifre giriniz."
            return false
        }
        
        guard agreeToTerms else {
            errorMessage = "Devam etmek için kullanım koşullarını kabul etmelisiniz."
            return false
        }
        
        return true
    }
}

