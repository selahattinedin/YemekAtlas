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
    
    @State private var selectedIngredients: [String: Bool] = [:]
    
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
                            .shadow(color: Color.red.opacity(0.5), radius: 1, x: 0, y: 0)
                            .colorMultiply(.pink)
                    
                    }
                    .padding(.trailing)
                    .offset(y: -24)
                }
            }
            
           
            VStack(alignment: .center, spacing: 16) {
                HStack {
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                HStack(spacing: 12) {
                                    InfoPill(icon: "flame", text: "\(recipe.calories)", subtext: "Cal")
                                    InfoPill(icon: "carrot.fill", text: "\(recipe.protein)", subtext: "Protein")
                                    InfoPill(icon: "drop.fill", text: "\(recipe.fat)", subtext: "Fat")
                                    InfoPill(icon: "leaf.fill", text: "\(recipe.carbohydrates)", subtext: "Carb")
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
                    .fill(Color.white.opacity(0.0))
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            )
            .padding()
            .colorMultiply(.pink)
         
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if selectedTab == "Malzemeler" {
                        ForEach(recipe.ingredients, id: \.self) { ingredient in
                            HStack {
                                Image(systemName: "fork.knife.circle")
                                    .foregroundColor(.primary)
                                Text("\(ingredient)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .lineSpacing(10)
                            
                                Spacer()
                                Button(action: {
                                    selectedIngredients[ingredient] = !(selectedIngredients[ingredient] ?? false)
                                }) {
                                    Image(systemName: selectedIngredients[ingredient] ?? false ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.pink)
                                }
                            }
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
                                HStack {
                                    Text("\u{2022} \(allergen)")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                        .lineSpacing(8)
                                    Spacer()
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)
                                }
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
struct IngredientRow: View {
    let amount: String
    let item: String

    var body: some View {
        HStack {
            Circle()
                .fill(Color.pink)
                .frame(width: 8, height: 8)
            Text(amount)
                .fontWeight(.medium)
            Text(item)
                .foregroundColor(.black)
            Spacer()
        }
    }
}





struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            name: "Biftek",
            ingredients: ["Biftek", "Karabiber", "Ketçap", "Mayonez", "Salça sosu"],
            calories: 250,
            protein: 8,
            carbohydrates: 45,
            fat: 3,
            allergens: ["Karabiber"],
            instructions: """
            1. Kıymayı geniş bir kaba alın.
            2. Tuz, karabiber, pul biber ve ezilmiş sarımsağı ekleyin.
            3. Karışımı iyice yoğurun ve şişlere geçirin.
            4. Kömür ateşinde veya ızgarada pişirin.
            5. Sıcak servis edin.
            """,
            imageURL: "https://pixabay.com/photos/pasta-italian-cuisine-dish-3547078/"
        )
        
        return RecipeDetailView(recipe: sampleRecipe)
    }
}














