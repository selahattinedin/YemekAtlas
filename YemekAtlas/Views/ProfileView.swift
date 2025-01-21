//
//  ProfileView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//


import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewViewModel()
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Image("Ben")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        Spacer()
                        HStack(spacing: 8) {
                            VStack {
                                Text("0")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Posts")
                                    .font(.subheadline)
                                    .frame(width: 76)
                            }
                            VStack {
                                Text("10")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Takipçi")
                                    .font(.subheadline)
                                    .frame(width: 76)
                            }
                            VStack {
                                Text("10")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Takip")
                                    .font(.subheadline)
                                    .frame(width: 76)
                            }
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selahattin Edin")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    Button {
                        showLogoutAlert = true
                    } label: {
                        Text("Çıkış Yap")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(width: 365, height: 32)
                            .foregroundStyle(.white)
                            .background(Color.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                    .padding(.vertical)
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationDestination(isPresented: $isLoggedOut) {
            LoginView()
        }
       
        .overlay {
            CustomAlertView(
                title: "Çıkış Yap",
                message: "Hesabınızdan çıkış yapmak istediğinize emin misiniz?",
                confirmButtonTitle: "Çıkış Yap",
                cancelButtonTitle: "İptal",
                confirmAction: {
                    viewModel.logout { success in
                        if success {
                            isLoggedOut = true
                        }
                    }
                },
                cancelAction: {},
                isPresented: $showLogoutAlert
            )
        }
    }
}

#Preview {
    ProfileView()
}





