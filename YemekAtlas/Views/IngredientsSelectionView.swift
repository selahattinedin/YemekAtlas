//
//  IngredientsSelectionView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 4.02.2025.
//

import SwiftUI

struct IngredientSelectionView: View {
    @StateObject private var viewModel = IngredientsViewModel()
    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss
    private let mainColor = Color("foodbackcolor")
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 3)
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.categories) { category in
                        CategoryButton(
                            name: category.name,
                            isSelected: viewModel.selectedCategory == category.name,
                            action: { viewModel.selectedCategory = category.name }
                        )
                    }
                }
                .padding()
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.filteredIngredients) { ingredient in
                        IngredientCard(
                            ingredient: ingredient,
                            isSelected: viewModel.selectedIngredients.contains(ingredient.name)
                        ) {
                            if viewModel.selectedIngredients.contains(ingredient.name) {
                                viewModel.selectedIngredients.remove(ingredient.name)
                            } else {
                                viewModel.selectedIngredients.insert(ingredient.name)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: {
                searchText = Array(viewModel.selectedIngredients).joined(separator: ", ")
                dismiss()
            }) {
                Text("Malzemeleri Ekle")
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(mainColor)
                    .cornerRadius(15)
            }
            .padding()
        }
    }
}

struct CategoryButton: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    private let mainColor = Color("foodbackcolor")
    
    var body: some View {
        Button(action: action) {
            Text(name)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(isSelected ? mainColor : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(mainColor, lineWidth: 1)
                )
        }
    }
}
#Preview {
    IngredientSelectionView(searchText: .constant(""))
}
