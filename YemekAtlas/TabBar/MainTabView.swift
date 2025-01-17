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
    
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(TabSelection.search)
            
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
}

#Preview {
    MainTabView()
}
