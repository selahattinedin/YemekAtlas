//
//  FavouriteRecipeView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 21.01.2025.
//

import SwiftUI
struct FavoriteView: View {
    @StateObject private var favoritesManager = FavoriteRecipesManager()
    @State private var showAlert = false
    @State private var recipeToDelete: Recipe?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
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
                                        RecipesCardView(recipe: recipe)
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
            .navigationTitle("Favori Tariflerim")
            .background(Color(.systemBackground))
        }
        .overlay {
            if let recipe = recipeToDelete {
                CustomAlertView(
                    title: "Tarifi Sil",
                    message: "\(recipe.name) adlı tarifi silmek istiyor musunuz?",
                    confirmButtonTitle: "Sil",
                    cancelButtonTitle: "İptal",
                    confirmAction: {
                        print("✅ Silme işlemi başlatılıyor...") // 💡 Debugging için ekledik
                        if let index = favoritesManager.favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
                            print("🔍 Silinecek tarif bulundu: \(recipe.name), Index: \(index)")
                            favoritesManager.removeFavorite(at: IndexSet(integer: index))
                        } else {
                            print("❌ Tarif bulunamadı! Listede yok.")
                        }
                        recipeToDelete = nil
                    },
                    cancelAction: {
                        print("❌ Silme işlemi iptal edildi.")
                        recipeToDelete = nil
                    },
                    isPresented: $showAlert
                )
            }
        }

    }
}

#Preview {
    FavoriteView()
}

