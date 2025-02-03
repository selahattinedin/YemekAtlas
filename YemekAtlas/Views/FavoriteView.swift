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
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Favori Tariflerim")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                                   
                            HStack {
                                Text("\(favoritesManager.favoriteRecipes.count)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                       
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .imageScale(.small)
                                       
                                Text("Tarif")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                               
                               Spacer()
                           }
                           .padding(.horizontal)
                           .padding(.vertical, 10)
                    
                    if favoritesManager.favoriteRecipes.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "heart.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("Favori Tarif Bulunamadı")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Beğendiğiniz tarifleri favorilerinize ekleyebilirsiniz")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ],
                            spacing: 12
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
                                        Image(systemName: "trash.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white.opacity(0.8))
                                            .clipShape(Circle())
                                    }
                                    .padding(8)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .navigationBarHidden(true)
        }
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
    }
}

#Preview {
    FavoriteView()
}

