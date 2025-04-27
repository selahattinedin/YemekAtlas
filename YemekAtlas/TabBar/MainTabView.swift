import SwiftUI

struct MainTabView: View {
    @State var selectedTab: TabSelection = .search
    @EnvironmentObject private var localeManager: LocaleManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SearchView(user: User(id: "1", name: "", email: "", joined: Date().timeIntervalSince1970))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(LocalizedStringKey("Search"))
                }
                .tag(TabSelection.search)
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart")
                    Text(LocalizedStringKey("Favorite"))
                }
                .tag(TabSelection.favorite)
            
            FoodMatchingView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text(LocalizedStringKey("Game"))
                }
                .tag(TabSelection.game)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text(LocalizedStringKey("Setting"))
                }
                .tag(TabSelection.profile)
            
           
        }
        .accentColor(.orange)
        .environment(\.locale, localeManager.locale)
    }
}

enum TabSelection {
    case search
    case profile
    case favorite
    case game
}

#Preview {
    MainTabView()
        .environmentObject(LocaleManager.shared)
}
