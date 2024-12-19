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
                    .offset(y: -24)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 6) {
                    // Dish Title and Total Time
                    HStack {
                        Text(recipe.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Spacer()
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.pink)
                                Text("30 Dakika")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)

                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                Text("\(recipe.calories) Kalori")            .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                    }
                    
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
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
           
            Picker(selection: $selectedTab, label: Text("Tabs")) {
                ForEach(tabs, id: \ .self) { tab in
                    Text(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .colorMultiply(.pink)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .padding()
            
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if selectedTab == "Malzemeler" {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(recipe.ingredients, id: \ .self) { ingredient in
                                Text("\u{2022} \(ingredient)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.leading, 8)
                                    .lineSpacing(8)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    } else if selectedTab == "Yapılış" {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(recipe.instructions)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.leading, 8)
                                .lineSpacing(8)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    } else if selectedTab == "Ek Bilgiler" {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Alerjenler:")
                                .font(.headline)
                                .foregroundColor(.pink)
                                .padding(.leading, 8)
                                .lineSpacing(8)
                            
                            if recipe.allergens.isEmpty {
                                Text("Bulunmuyor")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 8)
                                    .lineSpacing(8)
                            } else {
                                ForEach(recipe.allergens, id: \ .self) { allergen in
                                    Text("• \(allergen)")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .padding(.leading, 8)
                                        .lineSpacing(8)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .font(.body)
                .padding()
            }
            .frame(maxHeight: .infinity)
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











