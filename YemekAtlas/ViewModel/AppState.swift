//
//  AppState.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 29.03.2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isFirstLaunch = true
    
    static let shared = AppState()
    
    func signOut() {
        isAuthenticated = false
        isFirstLaunch = true
    }
}
