import SwiftUI

struct RecipesCardView: View {
    let recipe: Recipe
    @StateObject private var viewModel = RecipeDetailViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            // Full bleed image
            if let imageURL = viewModel.generatedImageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 160, height: 170)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 170)
                            .clipped()
                    case .failure:
                        Image(recipe.imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 170)
                            .clipped()
                    @unknown default:
                        Image(recipe.imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 170)
                            .clipped()
                    }
                }
                .cornerRadius(16)
            } else {
                Image(recipe.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 170)
                    .clipped()
                    .cornerRadius(16)
            }

            // Dark gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(16)

            // Content overlay
            VStack(alignment: .leading, spacing: 6) {
                Spacer()

                // Recipe name
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Calories and allergen info
                HStack {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(recipe.calories) kcal")
                            .foregroundColor(.white)
                    }
                    .font(.caption)

                    Spacer()

                    if !recipe.allergens.isEmpty {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            .padding(10)
        }
        .frame(width: 160, height: 170)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .onAppear {
            viewModel.setRecipe(recipe)
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        RecipesCardView(recipe: Recipe(
            name: "Chicken Salad",
            ingredients: ["chicken_breast", "lettuce", "tomatoes"],
            calories: 350,
            protein: 25,
            carbohydrates: 15,
            fat: 12,
            allergens: ["nuts"],
            instructions: "1. Cook the chicken. 2. Mix with lettuce and tomatoes.",
            imageURL: "placeholder1",
            clock: 20
        ))
        RecipesCardView(recipe: Recipe(
            name: "Margherita Pizza",
            ingredients: ["flour_250g", "tomato_sauce_100g", "mozzarella_200g"],
            calories: 270,
            protein: 12,
            carbohydrates: 30,
            fat: 10,
            allergens: [],
            instructions: "1. Prepare the dough. 2. Add toppings. 3. Bake in the oven.",
            imageURL: "placeholder2",
            clock: 30
        ))
    }
}
