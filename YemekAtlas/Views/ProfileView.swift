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

    let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]

    var body: some View {
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
                        Text("10")
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
                // Profil düzenleme işlevi
            } label: {
                Text("Profili Düzenle")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 365, height: 32)
                    .foregroundStyle(.black)
                    .overlay {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.pink, lineWidth: 1)
                    }
            }
            .padding(.bottom)

            // Logout Butonu
            Button {
                viewModel.logout { success in
                    if success {
                        isLoggedOut = true
                    }
                }
            } label: {
                Text("Çıkış Yap")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(width: 365, height: 32)
                    .foregroundStyle(.white)
                    .background(Color.pink)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
            }
            .padding()

            Spacer()
        }
        .navigationDestination(isPresented: $isLoggedOut) {
            LoginView()
        }
        .alert(isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
            Alert(title: Text("Hata"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Tamam")))
        }
    }
}

#Preview {
    ProfileView()
}
