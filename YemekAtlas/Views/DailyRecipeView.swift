//
//  DailyRecipeView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 5.12.2024.
//

import SwiftUI

struct DailyRecipeView: View {
    @StateObject private var viewModel = DailyRecipeViewViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Günün Yemeği")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.pink)
                
                Spacer()
            }
            .padding(.horizontal)
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.pink)
                    .scaleEffect(1.2)
            } else if let recipe = viewModel.dailyRecipe {
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(recipe.name)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 15) {
                            Label("\(recipe.calories) kcal", systemImage: "flame.fill")
                                .foregroundColor(.orange)
                            
                            if !recipe.allergens.isEmpty {
                                Label(recipe.allergens.joined(separator: ", "),
                                      systemImage: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .font(.system(size: 14, weight: .medium))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.3), radius: 5)
                    )
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            Task {
                if viewModel.dailyRecipe == nil {
                    await viewModel.fetchDailyRecipe()
                }
            }
        }
    }
}



#Preview {
    DailyRecipeView()
}
