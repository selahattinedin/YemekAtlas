//
//  IngredientsCardView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 4.02.2025.
//

import SwiftUI
import Kingfisher

struct IngredientCard: View {
    let ingredient: Ingredient
    let isSelected: Bool
    let action: () -> Void
    private let mainColor = Color("foodbackcolor")
    
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack(alignment: .topTrailing) {
                    KFImage(URL(string: ingredient.imageUrl))
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                        .foregroundColor(isSelected ? mainColor : .black)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 5, y: -5)
                }
                
                Text(ingredient.name)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .padding(8)
            .background(Color(.systemGray6).opacity(0.7))
            .cornerRadius(10)
        }
    }
}


#Preview {
    IngredientCard(ingredient: Ingredient(name: "", imageUrl:"", category: ""), isSelected: true, action: {})
}
