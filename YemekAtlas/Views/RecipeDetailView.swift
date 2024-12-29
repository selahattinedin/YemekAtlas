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
    @StateObject private var favoritesManager = FavoriteRecipesManager()

    
    let recipe: Recipe
    let tabs = ["Malzemeler", "Yapılış", "Alerjenler"]
    
    var body: some View {
        
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
                                .background(Color.orange)
                                .clipShape(Circle())
                        }
                        .padding(.leading)
                        Spacer()
                        
                        Button(action: {
                                                favoritesManager.toggleFavorite(recipe: recipe)
                                            }) {
                                                Image(systemName: favoritesManager.isFavorite(recipe: recipe) ? "heart.fill" : "heart")
                                                    .font(.title2)
                                                    .foregroundColor(favoritesManager.isFavorite(recipe: recipe) ? .red : .white)
                                                    .padding(12)
                                                    .background(Color.black.opacity(0.3))
                                                    .clipShape(Circle())
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
                        InfoPill(icon: "flame", text: "\(recipe.calories)", subtext: "Kal")
                        InfoPill(icon: "carrot.fill" , text: "\(recipe.protein) gr", subtext: "Protein")
                        InfoPill(icon: "drop.fill", text: "\(recipe.fat) gr", subtext: "Yağ")
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
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                                .frame(width: 100, height: 40)
                                .background(
                                    selectedTab == tab ? Color.orange : Color.clear
                                )
                                .cornerRadius(20)
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
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color(.orange), lineWidth: 1)
                                                )
                                        )
                                                            
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
                                    .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color(.orange), lineWidth: 1)
                                                    )
                                            )
                                    
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
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(.orange), lineWidth: 1)
                                        )
                                )
                                                                
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding(.top, -20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.top)
            .onAppear {
            favoritesManager.loadFavoriteRecipes()
            }
        }
    }


struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleRecipe = Recipe(
            name: "Sarımsak yağı soslu biftek",
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






