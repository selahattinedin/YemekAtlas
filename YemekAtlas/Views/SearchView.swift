import SwiftUI
import GoogleGenerativeAI
import Lottie

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewViewModel()
    @StateObject private var searchManager = RecentSearchesManager()
    @FocusState private var isSearchFocused: Bool
    @State private var showIngredientSelector = false
    @ObservedObject private var localeManager = LocaleManager.shared
    @State private var isExpanded = false
    @State private var searchOffset: CGFloat = 0
    @State private var showInputs = true
    
    var user: User
    private let mainColor = Color("foodbackcolor")
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {

                        GeometryReader { geometry in
                            let minY = geometry.frame(in: .global).minY
                            let scrollUpOffset = minY > 0 ? -minY : 0
                            let opacity = (200 + minY) / 200
                            
                            ZStack {
                                Image("Pizza")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: 300 + (minY > 0 ? minY : 0))
                                    .clipped()
                                    .overlay(
                                        LinearGradient(
                                            colors: [
                                                mainColor.opacity(0.7),
                                                mainColor.opacity(0.5)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .offset(y: scrollUpOffset)
                                
                                VStack {
                                    Text(LocalizedStringKey("food_atlas"))
                                        .font(.system(size: 40, weight: .heavy))
                                        .foregroundColor(.white)
                                        .shadow(radius: 2)
                                    
                                    Text(LocalizedStringKey("What_do_you_want_to_eat_today?"))
                                        .font(.title3)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .offset(y: scrollUpOffset)
                                .opacity(opacity)
                            }
                        }
                        .frame(height: 300)
                        
                        VStack(spacing: 15) {
                            if showInputs {
                                VStack(spacing: 16) {
                                    // Search Bar
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 22, weight: .semibold))
                                            .foregroundColor(.gray)
                                        
                                        TextField(LocalizedStringKey("What do you want to cook?"), text: $viewModel.searchText)
                                            .font(.system(size: 18, weight: .medium))
                                            .focused($isSearchFocused)
                                            .submitLabel(.search)
                                            .autocorrectionDisabled()
                                            .onSubmit {
                                                validateAndSearch()
                                            }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                                    )
                                    
                                    HStack(spacing: 15) {
                                        GradientButtonView(
                                            icon: "square.grid.2x2",
                                            title: LocalizedStringKey("Ingredients")
                                        ) {
                                            showIngredientSelector = true
                                        }
                                        
                                        GradientButtonView(
                                            icon: "arrow.right",
                                            title: LocalizedStringKey("Search"),
                                            startColor: Color(red: 0.5, green: 0.1, blue: 1.0),
                                            endColor: Color(red: 0.0, green: 0.5, blue: 1.0)
                                        ) {
                                            validateAndSearch()
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            VStack(spacing: 2) {
                                RecentSearchesView(searchManager: searchManager)
                                DailyRecipeView()
                                ChefSpecialsView()
                            }
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedShape()
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                        )
                        .offset(y: -50)
                    }
                }
                
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.9)
                            .edgesIgnoringSafeArea(.all)
                        LoadingView()
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .sheet(isPresented: $showIngredientSelector) {
                IngredientSelectionView(searchText: $viewModel.searchText)
            }
            .animation(.easeInOut(duration: 0.3), value: showInputs)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isLoading)
            .navigationDestination(item: $viewModel.recipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
    
    private func validateAndSearch() {
        guard !viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        searchWithAnimation()
    }
    
    private func searchWithAnimation() {
        Task {
            viewModel.isLoading = true
            withAnimation {
                showInputs = false
            }
            
            await viewModel.fetchRecipe()
            
            viewModel.isLoading = false
            if let recipe = viewModel.recipe {
                searchManager.addSearch(recipe)
            }
            
            withAnimation {
                showInputs = true
            }
        }
    }
}

struct RoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 50))
        path.addQuadCurve(to: CGPoint(x: width, y: 50),
                         control: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    SearchView(user: User(id: "1", name: "John", email: "john@example.com", joined: 0))
}
