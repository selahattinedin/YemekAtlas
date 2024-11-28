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

    var body: some View {
        
        NavigationStack {
                    VStack {
                        VStack(spacing: 16) {
                            
                            Text("Yemek Atlas")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.pink)
                                .multilineTextAlignment(.center)

                            
                            Text("Anne tarifleri kadar lezzetli sonuçlar sizi bekliyor.Hadi hemen deneyin.")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 16) 

                        .padding()
                        
                        HStack {
                            TextField("Bugün ne yemek istersin", text: $viewModel.searchText)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    HStack {
                                        Spacer()
                                        if !viewModel.searchText.isEmpty {
                                            Button(action: {
                                                viewModel.searchText = ""
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 12)
                                            }
                                        }
                                    }
                                )
                                .onSubmit {
                                    Task {
                                        await viewModel.fetchRecipe()
                                    }
                                }
                            
                            Button {
                                Task {
                                    await viewModel.fetchRecipe()
                                }
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.pink)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        
                        if viewModel.isLoading {
                            VStack(spacing: 10) {
                                ProgressView()
                                Text("Tarif aranıyor...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.body)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        if let recipe = viewModel.recipe {
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recipe.name)
                                        .font(.headline)
                                    Text("\(recipe.calories) kalori")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        
                    
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Sağlıklı ipuçları")
                                .font(.title2)
                                .bold()
                                .padding(.top)
                            
                            ForEach(healthTips, id: \.self) { tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.pink)
                                    Text(tip)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(radius: 5)
                        )
                        .padding()
                        
                        Spacer()
                    }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.white, .gray.opacity(0.1)]),
                                      startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    )
                }
            }
            
            let healthTips = [
                "Her gün mutlaka 2 litre su iç .",
                "Yemeklerinde kesinlikle yeşilliğe yer ver.",
                "Her gün mutlaka kalori hesabı yap.",
                "Şekeri çok fazla tüketme.",
                "Soğuk içiniz."
            ]
        }


    


#Preview {
    SearchView()
}
