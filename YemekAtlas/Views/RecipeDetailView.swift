import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = RecipeDetailViewModel()
    @StateObject private var favoritesManager = FavoriteRecipesManager()
    let recipe: Recipe
    var isRecipeFavorite: Bool {
        favoritesManager.isFavorite(recipe: recipe)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection(geometry)
                        contentSection
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    func headerSection(_ geometry: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            Image("Pizza")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                .clipped()
            
            VStack {
                HStack {
                    backButton
                    Spacer()
                    favoriteButton
                }
                .padding(.horizontal)
                .padding(.top, geometry.safeAreaInsets.top)
                
                Spacer()
            }
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
    }
    
    @ViewBuilder
    var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .padding(12)
                .background(Color.orange)
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    var favoriteButton: some View {
        Button(action: { favoritesManager.toggleFavorite(recipe: recipe) }) {
            Image(systemName: isRecipeFavorite ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundColor(isRecipeFavorite ? .red : .white)
                .padding(12)
                .background(Color.black.opacity(0.3))
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    var contentSection: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.white.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 15)
            
            recipeHeader
            nutritionInfo
            tabSelector
            tabContent
            Spacer(minLength: 20)
        }
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .edgesIgnoringSafeArea(.bottom)
        )
        .offset(y: -30)
    }
    
    @ViewBuilder
    var recipeHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.name)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Western")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    var nutritionInfo: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(nutritionItems, id: \.icon) { item in
                    InfoPill(icon: item.icon,
                             text: LocalizedStringKey(item.value),
                             subtext: LocalizedStringKey(item.unit))
                    .frame(width: geo.size.width / CGFloat(nutritionItems.count))
                }
            }
            .frame(height: 90)
        }
        .frame(height: 90)
        .padding(.vertical, 4)
    }
    
    private var nutritionItems: [(icon: String, value: String, unit: String)] {
        [
            ("clock", "\(recipe.clock)", "Min"),
            ("flame", "\(recipe.calories)", "Cal"),
            ("carrot.fill", "\(recipe.protein) g", "Protein"),
            ("drop.fill", "\(recipe.fat) g", "Fat"),
            ("leaf.fill", "\(recipe.carbohydrates) g", "Carb")
        ]
    }
    
    @ViewBuilder
    var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.tabs, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
    
    @ViewBuilder
    func tabButton(_ tab: String) -> some View {
        Button(action: { viewModel.selectedTab = tab }) {
            Text(LocalizedStringKey(tab))
                .fontWeight(viewModel.selectedTab == tab ? .bold : .regular)
                .foregroundColor(viewModel.selectedTab == tab ? .white : .gray)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(viewModel.selectedTab == tab ? Color.orange : Color.clear)
                .cornerRadius(20)
                .animation(.easeInOut, value: viewModel.selectedTab)
        }
    }
    
    @ViewBuilder
    var tabContent: some View {
        switch viewModel.selectedTab {
        case "Ingredients":
            ingredientsTab
        case "Instructions":
            instructionsTab
        case "Allergens":
            allergensTab
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var ingredientsTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Recipe Ingredients")
            
            ForEach(recipe.ingredients, id: \.self) { ingredient in
                ingredientRow(ingredient)
            }
        }
    }
    
    @ViewBuilder
    func ingredientRow(_ ingredient: String) -> some View {
        HStack {
            Image(systemName: "fork.knife.circle")
                .foregroundColor(.primary)
            
            Text(ingredient)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
            
            Button(action: { viewModel.toggleIngredient(ingredient) }) {
                Image(systemName: viewModel.selectedIngredients.contains(ingredient) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange, lineWidth: 2)
                .background(Color.white)
        )
    }
    
    @ViewBuilder
    var instructionsTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Preparation Steps")
            
            ForEach(Array(recipe.instructions.components(separatedBy: "\n").enumerated()), id: \.element) { index, step in
                if !step.isEmpty {
                    instructionStepRow(index + 1, step: step)
                }
            }
        }
    }
    
    @ViewBuilder
    func instructionStepRow(_ number: Int, step: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(number)")
                .font(.headline)
                .foregroundColor(.orange)
            
            Text(step)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange, lineWidth: 2)
                .background(Color.white)
        )
    }
    
    @ViewBuilder
    var allergensTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Allergen Information")
            
            if recipe.allergens.isEmpty {
                noAllergensView
            } else {
                ForEach(recipe.allergens, id: \.self) { allergen in
                    allergenRow(allergen)
                }
            }
        }
    }
    
    @ViewBuilder
    var noAllergensView: some View {
        HStack {
            Text("No allergens found.")
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    @ViewBuilder
    func allergenRow(_ allergen: String) -> some View {
        HStack {
            Text(allergen)
                .font(.headline)
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange, lineWidth: 2)
                .background(Color.white)
        )
    }

    @ViewBuilder
    func sectionTitle(_ title: String) -> some View {
        Text(LocalizedStringKey(title))
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom, 8)
    }
}


// MARK: - Preview
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
        
        RecipeDetailView(recipe: sampleRecipe)
            .environmentObject(FavoriteRecipesManager())
            .environmentObject(RecipeDetailViewModel())
            .previewLayout(.sizeThatFits)
    }
}
