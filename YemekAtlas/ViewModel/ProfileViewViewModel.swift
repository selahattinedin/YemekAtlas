//
//  ProfileViewViewModel.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import Foundation
import FirebaseAuth

class ProfileViewViewModel: ObservableObject {
    @Published var errorMessage: String = ""

    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true) // Çıkış başarılı
        } catch let error {
            errorMessage = "Çıkış işlemi başarısız: \(error.localizedDescription)"
            completion(false)
        }
    }
}

