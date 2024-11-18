//
//  MainTabView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab: TabSelection = .home
        
        var body: some View {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(TabSelection.home)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(TabSelection.search)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag(TabSelection.profile)
            }
            .accentColor(.pink)
        }
    }

enum TabSelection {
    case home
    case search
    case profile
}


#Preview {
    MainTabView()
}
