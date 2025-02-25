import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = "Ingredients"
    @State private var selectedIngredients: [String: Bool] = [:]
    @StateObject private var favoritesManager = FavoriteRecipesManager()
    
    let recipe: Recipe
    let tabs = [
        NSLocalizedString("Ingredients", comment: ""),
        NSLocalizedString("Instructions", comment: ""),
        NSLocalizedString("Allergens", comment: "")
    ]
    
    var isRecipeFavorite: Bool {
        favoritesManager.isFavorite(recipe: recipe)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .top) {
                    Image("Pizza")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                        .clipped()
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
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
                            Spacer()
                            
                            Button(action: {
                                favoritesManager.toggleFavorite(recipe: recipe)
                            }) {
                                Image(systemName: isRecipeFavorite ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(isRecipeFavorite ? .red : .white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, geometry.safeAreaInsets.top + 10)
                        
                        Spacer()
                            .frame(height: geometry.size.height * 0.25)
                        
                        VStack {
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 40, height: 5)
                                .padding(.top, 15)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text(recipe.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)
                                
                                Text(String(localized: "Western"))
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                                    .padding(.horizontal)
                                    .padding(.top, -9)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 6) {
                                        InfoPill(icon: "clock", text: "\(recipe.clock)", subtext:("Min"))
                                        InfoPill(icon: "flame", text: "\(recipe.calories)", subtext:("Cal"))
                                        InfoPill(icon: "carrot.fill", text: "\(recipe.protein) g", subtext:("Protein"))
                                        InfoPill(icon: "drop.fill", text: "\(recipe.fat) g", subtext:("Fat"))
                                        InfoPill(icon: "leaf.fill", text: "\(recipe.carbohydrates) g", subtext: ("Carb" ))
                                    }
                                    .padding(.horizontal, 6)
                                    .frame(maxWidth: .infinity)
                                }
                                
                                HStack(spacing: 12) {
                                    Spacer()
                                    ForEach(tabs, id: \.self) { tab in
                                        Button(action: { selectedTab = tab }) {
                                            Text(tab)
                                                .fontWeight(selectedTab == tab ? .bold : .regular)
                                                .foregroundColor(selectedTab == tab ? .white : .gray)
                                                .frame(width: 100, height: 40)
                                                .background(selectedTab == tab ? Color.orange : Color.clear)
                                                .cornerRadius(20)
                                                .animation(.easeInOut(duration: 0.3), value: selectedTab)
                                        }
                                    }
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    if selectedTab == NSLocalizedString("Ingredients", comment: "") {
                                        Text(NSLocalizedString("Recipe Ingredients", comment: ""))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal)
                                        
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
                                    } else if selectedTab == NSLocalizedString("Instructions", comment: "") {
                                        Text(NSLocalizedString("Preparation Steps", comment: ""))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal)
                                        
                                        ForEach(Array(recipe.instructions.components(separatedBy: "\n").enumerated()), id: \.element) { index, step in
                                            if !step.isEmpty {
                                                VStack(alignment: .leading) {
                                                    Text(String(format: NSLocalizedString("Step %d", comment: ""), index + 1))
                                                        .font(.headline)
                                                        .foregroundColor(.orange)
                                                    Text(step)
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
                                    } else if selectedTab == NSLocalizedString("Allergens", comment: "") {
                                        Text(NSLocalizedString("Allergen Information", comment: ""))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.horizontal)
                                        
                                        ForEach(recipe.allergens.isEmpty ? [NSLocalizedString("No allergens found.", comment: "")] : recipe.allergens, id: \.self) { allergen in
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
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white)
                        )
                        .offset(y: -20)
                    }
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
            imageURL: "https://pixabay.com/photos/pasta-italian-cuisine-dish-3547078/",
            clock: 43
        )
        
        return RecipeDetailView(recipe: sampleRecipe)
    }
}
