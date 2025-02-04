import SwiftUI
import GoogleGenerativeAI
import Lottie


struct SearchView: View {
    @StateObject private var viewModel = SearchViewViewModel()
    @StateObject private var searchManager = RecentSearchesManager()
    @FocusState private var isSearchFocused: Bool
    @State private var showIngredientSelector = false
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
                        // Header Image
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
                                    Text("Yemek Atlas")
                                        .font(.system(size: 40, weight: .heavy))
                                        .foregroundColor(.white)
                                        .shadow(radius: 2)
                                    
                                    Text("Bugün ne yemek istersin \(user.name)")
                                        .font(.title3)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .offset(y: scrollUpOffset)
                                .opacity(opacity)
                            }
                        }
                        .frame(height: 300)
                        
                        VStack(spacing: 20) {
                            if showInputs {
                                VStack(spacing: 16) {
                                    HStack(spacing: 10) {
                                        // Search Bar
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .font(.system(size: 22, weight: .semibold))
                                                .foregroundColor(.gray)
                                            
                                            TextField("Ne yemek yapmak istersin?", text: $viewModel.searchText)
                                                .font(.system(size: 18, weight: .medium))
                                                .focused($isSearchFocused)
                                                .submitLabel(.search)
                                                .autocorrectionDisabled()
                                                .onSubmit {
                                                    searchWithAnimation()
                                                }
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 15)
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.white)
                                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                                        )
                                        
                                        // Ingredient Selection Button
                                        Button(action: {
                                            showIngredientSelector = true
                                        }) {
                                            Image(systemName: "square.grid.2x2")
                                                .font(.system(size: 22))
                                                .foregroundColor(.white)
                                                .frame(width: 50, height: 50)
                                                .background(Color.green)
                                                .clipShape(Circle())
                                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                                        }
                                        
                                        // Search Button
                                        Button(action: {
                                            searchWithAnimation()
                                        }) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "arrow.right")
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            }
                            
                            RecentSearchesView(searchManager: searchManager)
                                .padding(.vertical, 5)
                            
                            DailyRecipesView()
                                .padding(.bottom, 5)
                            
                            ChefSpecialsView()
                                .padding(.top, -10)
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
    
    private func searchWithAnimation() {
        withAnimation {
            showInputs = false
        }
        Task {
            viewModel.isLoading = true
            await viewModel.fetchRecipe()
            viewModel.isLoading = false
            if let recipe = viewModel.recipe {
                searchManager.addSearch(recipe)
                withAnimation {
                    showInputs = true
                }
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
