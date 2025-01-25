//
//  RecipesCardView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 25.01.2025.
//

import SwiftUI

struct RecipesCardView: View {
   let recipe: Recipe

   var body: some View {
       ZStack(alignment: .bottom) {
           // Full bleed image
           Image(recipe.imageURL)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .frame(width: 250, height: 250)
               .clipped()
               .cornerRadius(20)

           // Dark gradient overlay
           LinearGradient(
               gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
               startPoint: .top,
               endPoint: .bottom
           )
           .cornerRadius(20)

           // Content overlay
           VStack(alignment: .leading, spacing: 8) {
               Spacer()

               // Recipe name
               Text(recipe.name)
                   .font(.headline)
                   .foregroundColor(.white)
                   .lineLimit(2)

               // Calories and allergen info
               HStack {
                   HStack {
                       Image(systemName: "flame.fill")
                           .foregroundColor(.orange)
                       Text("\(recipe.calories) kcal")
                           .foregroundColor(.white)
                   }

                   Spacer()

                   if !recipe.allergens.isEmpty {
                       Image(systemName: "exclamationmark.triangle.fill")
                           .foregroundColor(.yellow)
                   }
               }
               .font(.caption)
           }
           .padding(12)
       }
       .frame(width: 250, height: 250)
       .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
   }
}

#Preview {
   RecipesCardView(recipe: Recipe(
       name: "Delicious Chicken Salad with Extra Long Name",
       ingredients: ["Chicken", "Lettuce", "Tomatoes"],
       calories: 350,
       protein: 25,
       carbohydrates: 15,
       fat: 12,
       allergens: ["Nuts"],
       instructions: "Mix and serve",
       imageURL: "",
       clock: 20
   ))
}
