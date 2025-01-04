//
//  ProfileView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewViewModel()
    @StateObject private var favoritesManager = FavoriteRecipesManager()
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false
    @State private var showAlert = false
    @State private var recipeToDelete: Recipe?

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
                                Text("\(favoritesManager.favoriteRecipes.count)")
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

                    // Çıkış Yap butonu
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

                    // Favori Tariflerim bölümü
                    HStack {
                        Text("Favori Tariflerim")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    if favoritesManager.favoriteRecipes.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)

                            Text("Henüz favori tarifin yok")
                                .font(.headline)
                                .foregroundColor(.gray)

                            Text("Tarifleri beğenerek favorilerine ekleyebilirsin")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 30)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 16
                        ) {
                            ForEach(favoritesManager.favoriteRecipes) { recipe in
                                ZStack(alignment: .topTrailing) {
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        RecipesCard(recipe: recipe)
                                    }

                                    Button {
                                        recipeToDelete = recipe
                                        showAlert = true
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Color.white.opacity(0.8))
                                            .clipShape(Circle())
                                    }
                                    .offset(x: -8, y: 8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationDestination(isPresented: $isLoggedOut) {
            LoginView()
        }
        // Çıkış Yap Custom Alert
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
        // Tarif Silme Custom Alert
        .overlay {
            if let recipe = recipeToDelete {
                CustomAlertView(
                    title: "Tarifi Sil",
                    message: "\(recipe.name) adlı tarifi silmek istiyor musunuz?",
                    confirmButtonTitle: "Sil",
                    cancelButtonTitle: "İptal",
                    confirmAction: {
                        if let index = favoritesManager.favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
                            favoritesManager.removeFavorite(at: IndexSet(integer: index))
                        }
                        recipeToDelete = nil
                    },
                    cancelAction: {
                        recipeToDelete = nil
                    },
                    isPresented: $showAlert
                )
            }
        }
        .onAppear {
            favoritesManager.loadFavoriteRecipes()
        }
    }
}

#Preview {
    ProfileView()
}





