//
//  UserProfileDetailView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 14.02.2025.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel: ProfileViewViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let user = viewModel.user {
                Form {
                    Section("Kişisel Bilgiler") {
                        HStack {
                            Text("Ad Soyad")
                            Spacer()
                            Text(user.name)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("E-posta")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Katılma Tarihi")
                            Spacer()
                            Text(Date(timeIntervalSince1970: user.joined)
                                .formatted(date: .abbreviated, time: .omitted))
                                .foregroundColor(.gray)
                        }
                        
                        if let lastLogin = user.lastLogin {
                            HStack {
                                Text("Son Giriş")
                                Spacer()
                                Text(Date(timeIntervalSince1970: lastLogin)
                                    .formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Profil Bilgileri")
    }
}





#Preview {
    NavigationStack {
        let viewModel = ProfileViewViewModel()
        // Test verilerini manuel olarak atayabilirsiniz
        return UserProfileView(viewModel: viewModel)
    }
}
