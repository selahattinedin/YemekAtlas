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
                RecipeDetailView(recipe: Recipe.init(name: "Spagetti", ingredients: [" spaghetti, karabiber, ketçap, mayonez, salçasosu"], calories: 250, allergens: ["karabiber"], instructions: "talimat kısmı", imageURL: "https://pixabay.com/photos/pasta-italian-cuisine-dish-3547078/"))
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
