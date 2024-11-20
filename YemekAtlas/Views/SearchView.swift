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
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Yemek Atlas")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.pink)
                            
                            Text("Anne tarifi kadar güzel sonuçlar burada.")
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        
                        HStack {
                            TextField("Ne yemek istersin", text: $viewModel.searchText)
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
                            NavigationLink(destination: HomeView(recipe: recipe)) {
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
                                        .foregroundColor(.green)
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
