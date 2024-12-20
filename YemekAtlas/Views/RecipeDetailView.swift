//
//  HomeView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct RecipeDetailView: View {
    @State private var selectedTab = "Malzemeler"
    @State private var isLiked = false
    
    let recipe: Recipe
    
    let tabs = ["Malzemeler", "Yapılış", "Alerjenler"]
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .topTrailing) {
               
                Image("steak")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 350)
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
                
          
                VStack {
                    Spacer()
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .white)
                            .font(.title2)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                            .shadow(color: Color.red.opacity(5.9), radius: 1, x: 0, y: 0)
                            .colorMultiply(.pink)
                    
                    }
                    .padding(.trailing)
                    .offset(y: -24)
                }
            }
            
           
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    NutritionInfo(icon: "flame.fill", color: .orange, label: "\(recipe.calories) Kcal")
                    NutritionInfo(icon: "drop.fill", color: .yellow, label: "4g Yağ")
                    NutritionInfo(icon: "carrot.fill", color: .orange, label: "15g Protein")
                    NutritionInfo(icon: "leaf.fill", color: .pink, label: "20g Karb.")
                }
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            .padding(.horizontal)
            
           
            Picker(selection: $selectedTab, label: Text("Tabs")) {
                            ForEach(tabs, id: \.self) { tab in
                                Text(tab)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                .colorMultiply(.pink)
                        )
            .padding()
            
         
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if selectedTab == "Malzemeler" {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            Text("\u{2022} \(ingredient)")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .lineSpacing(10)
                                
                        }
                    } else if selectedTab == "Yapılış" {
                        Text(recipe.instructions)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineSpacing(8)
                    } else if selectedTab == "Alerjenler" {
                        if recipe.allergens.isEmpty {
                            Text("Alerjen bulunmuyor.")
                                .font(.headline)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(recipe.allergens, id: \.self) { allergen in
                                Text("\u{2022} \(allergen)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineSpacing(8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}


struct NutritionInfo: View {
    let icon: String
    let color: Color
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
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
















