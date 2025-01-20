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
    @State private var showInputs = true  // Input alanlarını kontrol etmek için
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if showInputs {  // Input alanlarını koşullu göster
                    VStack(spacing: 8) {
                        Text("Yemek Atlas")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.orange)
                            .shadow(color: .orange.opacity(0.3), radius: 2, x: 0, y: 2)
                        
                        Text("Lezzet Yolculuğuna Hoş Geldiniz")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    .transition(.move(edge: .top).combined(with: .opacity))
                
                    VStack(spacing: 16) {
                        HStack(spacing: 15) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.yellow)
                            
                            TextField("Ne yemek yapmak istersin?", text: $viewModel.searchText)
                                .font(.system(size: 17))
                                .focused($isSearchFocused)
                                .submitLabel(.search)
                                .autocorrectionDisabled()
                                .onSubmit {
                                    searchWithAnimation()
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
                        
                        Button {
                            searchWithAnimation()
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
                                    colors: [.orange, .orange.opacity(0.6)],
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
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                if viewModel.isLoading {
                    Spacer()
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
                    .padding(.horizontal)
                    .transition(.opacity.animation(.easeIn(duration: 0.3)))
                    Spacer()
                }
                
                if !viewModel.isLoading && viewModel.recipe == nil && showInputs {
                    VStack(spacing: 16) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.popularRecipes) { recipe in
                                    RecipesCard(recipe: recipe)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    DailyRecipesView()
                        .padding(.top, -30)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showInputs)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
            .background(Color.white)
            .navigationDestination(item: $viewModel.recipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
    
    private func searchWithAnimation() {
        withAnimation {
            showInputs = false
        }
        Task {
            await viewModel.fetchRecipe()
            // Arama tamamlandığında inputları tekrar göster
            withAnimation {
                showInputs = true
            }
        }
    }
}

#Preview {
    SearchView()
}

    




    




