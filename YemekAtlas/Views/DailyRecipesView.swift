//
//  GunlukYemekView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.12.2024.
//
//


import SwiftUI
import Lottie

struct DailyRecipesView: View {
    @StateObject private var viewModel = DailyRecipesViewViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Günlük Tarifler")
                    .font(.title2.bold())
                    .foregroundColor(.orange)
                    .padding(.horizontal)
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
                            .fill(Color("foodbackcolor"))
                            .shadow(color: .orange.opacity(0.6), radius: 8, y: 4)
                    )
                }
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    LottieView(animationName: "Loading")
                        .frame(width: 150)
                        .scaleEffect(0.6)
                        .padding(.top, 10)
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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.dailyRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipesCardView(recipe: recipe)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.bottom, 30)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DailyRecipesView()
    }
}
