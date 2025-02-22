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
        // Debug: Checking email
        print("Checking email: \(email)")
        
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address."
            print("Error: Email is empty")
            completion(false)
            return
        }
        
        // Starting password reset process
        print("Starting password reset process...")
        
        // Firebase password reset process
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Firebase error message
                self.errorMessage = "An error occurred: \(error.localizedDescription)"
                print("Firebase Error: \(error.localizedDescription)")
                print("Error Type: \(type(of: error))")
                completion(false)
                return
            }
            
            // Success message
            self.successMessage = "A password reset link has been sent to your email address."
            print("Success: Password reset link sent.")
            completion(true)
        }
    }
    
    // Debug: Validating email
    func validateEmail() -> Bool {
        print("Validating email: \(email)")
        
        // Ensure the email format is correct
        let emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailTest.evaluate(with: email)
        
        if isValid {
            print("Valid email format: \(email)")
        } else {
            print("Invalid email format: \(email)")
        }
        
        return isValid
    }
    
    // Debug: Checking Firebase authentication status
    func checkFirebaseAuthStatus() {
        print("Checking Firebase authentication status...")
        if let currentUser = Auth.auth().currentUser {
            print("Logged-in user: \(currentUser.email ?? "Unknown")")
        } else {
            print("User is not logged in.")
        }
    }
}
