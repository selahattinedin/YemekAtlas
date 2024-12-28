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
                            .background(Color.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                    .padding(.vertical)

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
        .alert("Tarifi Sil", isPresented: $showAlert) {
            Button("Sil", role: .destructive) {
                if let recipe = recipeToDelete,
                   let index = favoritesManager.favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
                    favoritesManager.removeFavorite(at: IndexSet(integer: index))
                }
                recipeToDelete = nil
            }
            Button("İptal", role: .cancel) {
                recipeToDelete = nil
            }
        } message: {
            if let recipe = recipeToDelete {
                Text("\(recipe.name) adlı tarifi silmek istiyor musunuz?")
            } else {
                Text("Bilinmeyen bir hata oluştu.")
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
