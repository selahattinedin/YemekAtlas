// MainViewViewModel.swift
import Foundation
import FirebaseAuth

class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var isEmailVerified: Bool = false
    @Published var showVerificationView: Bool = false
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
                self?.isEmailVerified = user?.isEmailVerified ?? false
                
                // Kullanıcı giriş yapmış ama email doğrulanmamışsa
                if user != nil && !(user?.isEmailVerified ?? false) {
                    self?.showVerificationView = true
                }
            }
        }
    }
    
    public var isSignIn: Bool {
        return Auth.auth().currentUser != nil
    }
}

// MainView.swift
