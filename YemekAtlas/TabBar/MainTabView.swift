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
            
            RecipeDetailView(
                    recipe: Recipe(
                        name: "Spagetti",
                        ingredients: ["Spagetti", "Karabiber", "Ketçap", "Mayonez", "Salça sosu"],
                        calories: 250,
                        protein: 0,
                        carbohydrates: 0,
                        fat: 0,
                        allergens: ["Karabiber"],
                        instructions: "Makarnayı haşlayın. Sosları ekleyin ve karıştırın.",
                        imageURL: "https://pixabay.com/photos/pasta-italian-cuisine-dish-3547078/"
                    )
                )
                

            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            .tag(TabSelection.home)
            
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
    case home
    case search
    case profile
}

#Preview {
    MainTabView()
}
