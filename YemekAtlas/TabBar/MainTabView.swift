//
//  MainTabView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab: TabSelection = .search
    
    var body: some View {
        TabView(selection: $selectedTab) {
    
            SearchView(user: User(id: "1", name: "", email: "", joined: Date().timeIntervalSince1970))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(TabSelection.search)
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourite")
                }
                .tag(TabSelection.favorite)
            
            
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(TabSelection.profile)
        }
        .accentColor(.orange)
    }
}
  
enum TabSelection {
    
    case search
    case profile
    case favorite
}

#Preview {
    MainTabView()
}
