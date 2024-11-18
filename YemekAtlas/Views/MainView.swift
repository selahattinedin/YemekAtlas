//
//  ContentView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 19.10.2024.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isSignIn, !viewModel.currentUserId.isEmpty{
            MainTabView(selectedTab: .home)
        } else{
            LoginView()
        }
    }
}

#Preview {
    MainView()
}
