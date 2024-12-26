//
//  GunlukYemekView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.12.2024.
//
import SwiftUI

struct DailyRecipesView: View {
    @StateObject private var viewModel = DailyRecipesViewViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView { // Ekranın taşmasını önlemek için ScrollView kullanıldı
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        // Başlık ve Yenile Butonu
                        HStack {
                            Text("Günlük Tarifler")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                Task {
                                    await viewModel.fetchDailyRecipes()
                                }
                            }) {
                                HStack(spacing: 8) {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "arrow.clockwise")
                                    }
                                    Text(viewModel.isLoading ? "Yükleniyor..." : "Yenile")
                                }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.pink)
                                        .shadow(color: .pink.opacity(0.9), radius: 8, y: 4)
                                )
                            }
                            .disabled(viewModel.isLoading)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        // Yemek Kartları
                        if viewModel.isLoading {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("Tarifler yükleniyor...")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        } else if let errorMessage = viewModel.errorMessage {
                            VStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 40))
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.red)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        } else {
                            LazyVGrid(
                                columns: [
                                    GridItem(.fixed(140), spacing: 45),
                                    GridItem(.fixed(140), spacing: 45)
                                ],
                                spacing: 16
                            ) {
                                ForEach(viewModel.dailyRecipes) { recipe in
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        RecipesCard(recipe: recipe)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 30) // Alt kısmı dengelemek için ekstra boşluk
                }
            }
        }
    }
}

struct RecipesCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image("yemek")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .clipped()
                .cornerRadius(10)
            
            Text(recipe.name)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)
            
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
                Text("\(recipe.calories) kcal")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Spacer()
                if recipe.allergens.first != " " {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .frame(width: 150)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DailyRecipesView()
    }
}
