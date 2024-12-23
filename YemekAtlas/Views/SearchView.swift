//
//  SearchView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 29.10.2024.
//

import SwiftUI
import GoogleGenerativeAI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewViewModel()
    @FocusState private var isSearchFocused: Bool
    @State private var searchBarOffset: CGFloat = -100
    @State private var searchBarScale: CGFloat = 0.8

    var body: some View {
        NavigationStack {
            ZStack {
               
                LinearGradient(
                    gradient: Gradient(colors: [.white, .blue.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 8) {
                            Text("Yemek Atlas")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(.pink)
                                .shadow(color: .pink.opacity(0.3), radius: 2, x: 0, y: 2)

                            Text("Lezzet Yolculuğuna Hoş Geldiniz")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)

                        
                        VStack(spacing: 20) {
                            HStack(spacing: 15) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.pink)

                                TextField("Ne yemek yapmak istersin?", text: $viewModel.searchText)
                                    .font(.system(size: 17))
                                    .focused($isSearchFocused)
                                    .submitLabel(.search)
                                    .autocorrectionDisabled()
                                    .onSubmit {
                                        Task {
                                            await viewModel.fetchRecipe()
                                        }
                                    }

                                if !viewModel.searchText.isEmpty {
                                    Button(action: {
                                        viewModel.searchText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 20))
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(isSearchFocused ? Color.pink : Color.clear, lineWidth: 2)
                            )

                            Button {
                                Task {
                                    await viewModel.fetchRecipe()
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "sparkles")
                                    Text("Tarif Bul")
                                }
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(
                                    LinearGradient(
                                        colors: [.pink, .pink.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .shadow(color: .pink.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                            .opacity(viewModel.searchText.isEmpty ? 0.6 : 1)
                            .disabled(viewModel.searchText.isEmpty)
                        }

                        
                        if viewModel.isLoading {
                            VStack(spacing: 15) {
                                ProgressView()
                                    .scaleEffect(1.2)
                                    .tint(.pink)

                                Text("Tarifler Hazırlanıyor...")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.8))
                            )
                            .padding()
                        }

                        
                        if let recipe = viewModel.recipe {
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(recipe.name)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.primary)

                                    HStack(spacing: 15) {
                                        Label("\(recipe.calories) kcal", systemImage: "flame.fill")
                                            .foregroundColor(.orange)

                                        if !recipe.allergens.isEmpty {
                                            Label(recipe.allergens.joined(separator: ", "), systemImage: "exclamationmark.triangle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white)
                                        .shadow(radius: 10)
                                )
                                .padding(.horizontal)
                            }
                        }

                       
                        if !viewModel.isLoading && viewModel.recipe == nil {
                            DailyRecipeView()
                                .padding(.top, 30)

                            HealthTipsView()
                                .padding(.top, 10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}




    



