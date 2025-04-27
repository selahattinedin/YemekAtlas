//
//  CountrySelectionView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 27.04.2025.
//

import SwiftUI

struct CountrySelectionView: View {
    @ObservedObject var viewModel: FoodGameViewViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(LocalizedStringKey("Select Country Title"))
                .font(.title.bold())
                .foregroundColor(.primary)
            
            Text(LocalizedStringKey("Select Country Subtitle"))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(Country.popularCountries) { country in
                        Button(action: {
                            viewModel.selectCountry(country)
                        }) {
                            HStack {
                                Text(country.flag)
                                    .font(.title)
                                Text(country.name)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical)
            }
        }
    }
}


