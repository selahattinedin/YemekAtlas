//
//  HomeView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct HomeView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: recipe.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    } placeholder: {
                        ZStack {
                            Color.gray.opacity(0.3)
                                .frame(height: 300)
                            ProgressView()
                        }
                    }
                    .cornerRadius(20)
                    .shadow(radius: 10)

                    
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                                   startPoint: .bottom, endPoint: .top)
                        .cornerRadius(20)
                        .frame(height: 80)
                        .overlay(
                            Text(recipe.name)
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, 10),
                            alignment: .bottomLeading
                        )
                }
                .padding(.horizontal)

                
                VStack(alignment: .leading, spacing: 16) {
                    
                    HStack(spacing: 16) {
                        InfoBadge(title: "Calories", value: "\(recipe.calories)")
                        if !recipe.allergens.isEmpty {
                            InfoBadge(title: "Allergens", value: recipe.allergens.joined(separator: ", "), isWarning: true)
                        }
                    }

                    
                    SectionHeader(title: "Ingredients")
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            HStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                Text(ingredient)
                                    .font(.body)
                            }
                        }
                    }

                    
                    SectionHeader(title: "Instructions")
                    Text(recipe.instructions)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(5)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 10)
                )
                .padding(.horizontal)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.1)]),
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }
}


struct InfoBadge: View {
    let title: String
    let value: String
    var isWarning: Bool = false

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(isWarning ? .red : .primary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isWarning ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
        )
    }
}


struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.bottom, 4)
    }
}





#Preview {
    HomeView(recipe: Recipe.init(name: "spagetti", ingredients: [" spaghetti, karabiber, ketçap, mayonez, salçasosu"], calories: 250, allergens: ["karabiber"], instructions: "", imageURL: "https://pixabay.com/photos/pasta-italian-cuisine-dish-3547078/"))
}
