import SwiftUI

struct RecentSearchesView: View {
    @StateObject var searchManager: RecentSearchesManager
    @State private var showCustomAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(LocalizedStringKey("recent_searches"))
                    .font(.title2.bold())
                    .foregroundColor(.orange)
                
                Spacer()
                
                if !searchManager.recentSearches.isEmpty {
                    Button(action: {
                        showCustomAlert = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash")
                                .font(.system(size: 14, weight: .bold))
                            Text(LocalizedStringKey("clear"))
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("foodbackcolor"))
                                .shadow(color: Color.orange.opacity(0.4), radius: 8, y: 4)
                        )
                    }
                }
            }
            .padding(.horizontal)
            
            if searchManager.recentSearches.isEmpty {
                Text(LocalizedStringKey("no_recent_searches_found"))
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
        .overlay {
            CustomAlertView(
                title: LocalizedStringKey("clear_history"),
                message: LocalizedStringKey("are_you_sure_you_want_to_clear_all_recent_searches"),
                confirmButtonTitle: LocalizedStringKey("clear"),
                cancelButtonTitle: LocalizedStringKey("cancel"),
                confirmAction: {
                    searchManager.clearSearches()
                },
                cancelAction: {},
                isPresented: $showCustomAlert
            )
        }
    }
}

#Preview {
    RecentSearchesView(searchManager: RecentSearchesManager())
}
