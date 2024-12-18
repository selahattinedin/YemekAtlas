//
//  HomeView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct RecipeDetailView: View {
    @State private var selectedTab = "Malzemeler" // Default tab selection
    @State private var isLiked = false // Like button state
    
    let recipe: Recipe // Recipe model
    
    let tabs = ["Malzemeler", "Yapılış", "Ek Bilgiler"] // Tab titles
    
    var body: some View {
        VStack {
            // MARK: - Top Image with Buttons
            ZStack(alignment: .topTrailing) {
                // Background Image with Rounded Corners at Bottom
                Image("yemek") // Replace with your image asset name
                    .resizable()
                    .scaledToFill()
                    .frame(width: 405, height: 350)
                    .mask(
                        RoundedRectangle(cornerRadius: 45, style: .continuous)
                    )
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.black.opacity(0.5), .clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 45, style: .continuous)
                        )
                    )
                    .padding(.bottom, 8)
                
                // Like Button (Moved to Right Side, Centered Vertically)
                VStack {
                    Spacer()
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .white)
                            .font(.title2)
                            .padding(8)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                    .offset(y: -24) // Align to center relative to the dish
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 6) {
                    // Dish Title
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Text("Recipe")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("4.5")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4) // Shadow effect
                
            }
            .padding(.horizontal) // Padding around the card
            .padding(.bottom, 8) // Bottom padding
            
            // MARK: - Segmented Picker with Pink Highlight
            Picker(selection: $selectedTab, label: Text("Tabs")) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .tint(.pink) // Sets the tint color of the picker
            .padding(.horizontal)
            
            // MARK: - Content Area
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    if selectedTab == "Malzemeler" {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("\u{2022} \(ingredient)")
                        }
                    } else if selectedTab == "Yapılış" {
                        Text(recipe.instructions)
                    } else if selectedTab == "Ek Bilgiler" {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Alerjenler:")
                                .font(.headline)
                                .foregroundColor(.pink)
                            
                            if recipe.allergens.isEmpty {
                                Text("Bulunmuyor")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(recipe.allergens, id: \.self) { allergen in
                                    Text("• \(allergen)")
                                }
                            }
                        }
                    }
                }
                .font(.body)
                .padding()
            }
            .frame(maxHeight: .infinity)
            
            // MARK: - Bottom Info & Add Button
            HStack {
                VStack(alignment: .leading) {
                    // Total Time and Serving in Turkish and aligned with symbols
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.pink)
                        Text("Toplam Süre: 30 Dakika")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.pink)
                        Text("Porsiyon: 2 Kişilik")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pink)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            name: "Adana Kebabı",
            ingredients: [
                "500g kıyma",
                "1 tatlı kaşığı tuz",
                "1 çay kaşığı karabiber",
                "1 tatlı kaşığı pul biber",
                "1 baş sarımsak, ezilmiş"
            ],
            calories: 350,
            allergens: ["Gluten", "Süt ürünleri"],
            instructions: """
            1. Kıymayı geniş bir kaba alın.
            2. Tuz, karabiber, pul biber ve ezilmiş sarımsağı ekleyin.
            3. Karışımı iyice yoğurun ve şişlere geçirin.
            4. Kömür ateşinde veya ızgarada pişirin.
            5. Sıcak servis edin.
            """, imageURL: ""
        )
        
        return RecipeDetailView(recipe: sampleRecipe)
    }
}


