import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoriteRecipesManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(favoritesManager.favoriteRecipes, id: \.name) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            FavoriteRecipeCard(recipe: recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Favoriler")
        }
    }
}

struct FavoriteRecipeCard: View {
    let recipe: Recipe
    @StateObject private var viewModel = RecipeDetailViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = viewModel.generatedImageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Image(recipe.imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                    case .failure:
                        Image(recipe.imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                    @unknown default:
                        Image(recipe.imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                    }
                }
            } else {
                Image(recipe.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipped()
            }
            
            Text(recipe.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.caption)
                Text("\(recipe.calories) kcal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            viewModel.setRecipe(recipe)
        }
    }
}

#Preview {
    FavoritesView()
} 