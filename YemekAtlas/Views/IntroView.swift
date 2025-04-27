//
//  IntroView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 27.04.2025.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: FoodGameViewViewModel

    var body: some View {
        VStack(spacing: 30) {
            if let country = viewModel.selectedCountry {
                Text(LocalizedStringKey(String(format: String(localized: "Favorite Country Dish Format"), country.name)))
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            } else {
                Text(LocalizedStringKey("Favorite Dish Title"))
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text(LocalizedStringKey("Intro Description"))
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            GradientButtonView(icon: "play.fill", title: "Start Button") {
                viewModel.startGame()
            }
        }
    }
}



