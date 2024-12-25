//
//  LoginViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 22.10.2024.
//

import Foundation
import FirebaseAuth

class LoginViewViewModel : ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var errorMessage = ""
    
    init(){}
    
    func login(){
            guard validate()
            else {
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password)
          
            }
    
    func validate() -> Bool{
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else{
            errorMessage = "Lütfen tüm alanları doldurun."
            return false
        }
        
        guard email.contains("@") && email.contains(".com") else{
            errorMessage = "Lütfen geçerli bir email adresi giriniz."
            return false
            
        }
        return true
        
    }
    
}
