// MainView.swift
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = AuthViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            MainTabView(selectedTab: .search)
        } else {
            VStack {
                Text("Welcome to YemekAtlas")
                    .font(.largeTitle)
                    .padding()
                Button("Continue") {
                    viewModel.signInAnonymously()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
