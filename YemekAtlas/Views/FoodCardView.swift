//
//  FoodCardView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 27.04.2025.
//

import SwiftUI

struct FoodCardView: View {
    let food: Food
    let action: () -> Void

    var body: some View {
        ZStack {
            Image("welcomeImage2")
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 220)
                .clipped()
                .overlay(Color.black.opacity(0.6))

            VStack(spacing: 8) {
                Text(food.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(radius: 4)
                    .multilineTextAlignment(.center)

                Text(food.description)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 8)
                    .shadow(radius: 2)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.25))
            .cornerRadius(12)
            .padding(.bottom, 10)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .cornerRadius(16)
        .frame(width: 160, height: 220)
        .shadow(color: .gray.opacity(0.4), radius: 6, x: 0, y: 4)
        .onTapGesture {
            action()
        }
    }
}


