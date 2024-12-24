//
//  HomeView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = "Malzemeler"
    @State private var isLiked = false
    @State private var selectedIngredients: [String: Bool] = [:]
    
    let recipe: Recipe
    let tabs = ["Malzemeler", "Yapılış", "Alerjenler"]
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .top) {
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
                    
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Color.yellow)
                                .clipShape(Circle())
                        }
                        .padding(.leading)
                        Spacer()
                        
                        Button(action: {
                            isLiked.toggle()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .white)
                                .font(.title2)
                                .padding(12)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                                .shadow(color: Color.red.opacity(0.5), radius: 1, x: 0, y: 0)
                                .colorMultiply(.pink)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top, 60)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                    
                    Text("Western")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.top, -9)
                    
                    HStack(spacing: 12) {
                        InfoPill(icon: "clock", text: "45", subtext: "Dak")
                        InfoPill(icon: "flame", text: "\(recipe.calories)", subtext: "Cal")
                        InfoPill(icon: "carrot.fill" , text: "\(recipe.protein) gr", subtext: "Protein")
                        InfoPill(icon: "drop.fill", text: "\(recipe.fat) gr", subtext: "Fat")
                        InfoPill(icon: "leaf.fill", text: "\(recipe.carbohydrates) gr", subtext: "Carb")
                    }
                    .padding(.top, -5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 12) {
                    Spacer()
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: { selectedTab = tab }) {
                            Text(tab)
                                .fontWeight(selectedTab == tab ? .bold : .regular)
                                .foregroundColor(selectedTab == tab ? .black : .gray)
                                .frame(width: 100, height: 40)
                                .background(
                                    selectedTab == tab ? Color.orange.opacity(0.5) : Color.clear
                                )
                                .cornerRadius(8)
                                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 16)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if selectedTab == "Malzemeler" {
                            Text("Tarif Malzemeleri")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                HStack {
                                    Image(systemName: "fork.knife.circle")
                                        .foregroundColor(.primary)
                                    Text(ingredient)
                                        .font(.headline)
                                    Spacer()
                                    Button(action: {
                                        selectedIngredients[ingredient] = !(selectedIngredients[ingredient] ?? false)
                                    }) {
                                        Image(systemName: selectedIngredients[ingredient] ?? false ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding()
                                .background(Color.orange.opacity(0.3))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        } else if selectedTab == "Yapılış" {
                            Text("Hazırlanış Adımları")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            ForEach(Array(recipe.instructions.components(separatedBy: "\n").enumerated()), id: \.element) { index, step in
                                if !step.isEmpty {
                                    VStack(alignment: .leading) {
                                        Text("Adım \(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(.orange)
                                        Text(step.replacingOccurrences(of: "\\d+\\. ", with: "", options: .regularExpression))
                                            .font(.body)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.orange.opacity(0.3))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }
                        } else if selectedTab == "Alerjenler" {
                            Text("Alerjen Bilgileri")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                            ForEach(recipe.allergens.isEmpty ? ["Alerjen bulunmuyor."] : recipe.allergens, id: \.self) { allergen in
                                HStack {
                                    Text(allergen)
                                        .font(.headline)
                                    if !recipe.allergens.isEmpty {
                                        Spacer()
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(Color.orange.opacity(0.3))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.top, -20)
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
        }
    }
}




struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            name: "Sarımsak yağı soslu biftek",
            ingredients: ["Biftek", "Karabiber", "Ketçap", "Mayonez", "Salça sosu"],
            calories: 250,
            protein: 8 ,
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














