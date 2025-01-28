import SwiftUI

struct RecentSearchesView: View {
    @ObservedObject var searchManager: RecentSearchesManager // Dışarıdan veri aktarılıyor

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Geçmiş Aramalar")
                    .font(.title2.bold())
                    .foregroundColor(.orange)
                
                Spacer()
                
                if !searchManager.recentSearches.isEmpty {
                    Button(action: {
                        searchManager.clearSearches()
                    }) {
                        Text("Temizle")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            
            if searchManager.recentSearches.isEmpty {
                Text("Geçmiş arama bulunmamakta.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.top, 8)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(searchManager.recentSearches) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipesCardView(recipe: recipe)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    RecentSearchesView(searchManager: RecentSearchesManager())
}
