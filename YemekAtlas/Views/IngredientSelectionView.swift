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
            // Enhanced Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(mainColor)
                    .font(.system(size: 20))
                
                TextField("Malzeme Ara...", text: $viewModel.searchQuery)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16))
                    .tint(mainColor)
                
                if !viewModel.searchQuery.isEmpty {
                    Button(action: {
                        viewModel.searchQuery = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(mainColor)
                            .font(.system(size: 20))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: mainColor.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(mainColor.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.top)
            
            // Categories ScrollView
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
            
            // Ingredients Grid
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
            
            // Enhanced Add Button
            Button(action: {
                searchText = Array(viewModel.selectedIngredients).joined(separator: ", ")
                dismiss()
            }) {
                HStack(spacing: 12) {
                    Text("Malzemeleri Ekle")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    ZStack {
                        mainColor
                        
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: mainColor.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
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
