import SwiftUI

struct FoodMatchingView: View {
    @StateObject private var viewModel = FoodGameViewViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.2), Color.pink.opacity(0.4)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            NavigationView {
                            VStack {
                                if viewModel.showIntroView {
                                    IntroView(viewModel: viewModel)
                                } else if viewModel.showCountryPicker {
                                    CountrySelectionView(viewModel: viewModel)
                                } else if viewModel.isLoading {
                                    loadingView
                                } else if let errorMessage = viewModel.errorMessage {
                                    errorView(message: errorMessage)
                                } else if viewModel.matchingComplete {
                                    FinalResultView(viewModel: viewModel)
                                } else if let champion = viewModel.currentChampion, let challenger = viewModel.currentChallenger {
                                    matchupView(champion: champion, challenger: challenger)
                                }
                            }
                .padding()
                .navigationTitle(viewModel.selectedCountry == nil ?
                                LocalizedStringKey("Food Matching Title") :
                                LocalizedStringKey(String(format: String(localized: "Cuisine Title Format"), viewModel.selectedCountry!.flag, viewModel.selectedCountry!.name)))
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            // Debug print to help identify the view state
            print("View appeared. showCountryPicker: \(viewModel.showCountryPicker), isLoading: \(viewModel.isLoading), errorMessage: \(String(describing: viewModel.errorMessage)), matchingComplete: \(viewModel.matchingComplete), champion: \(String(describing: viewModel.currentChampion)), challenger: \(String(describing: viewModel.currentChallenger))")
        }
    }
    
    var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .padding()
            
            if let country = viewModel.selectedCountry {
                Text(LocalizedStringKey(String(format: String(localized: "Generating Foods Format"), country.name)))
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func errorView(message: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text(LocalizedStringKey("Error Title"))
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack(spacing: 16) {
                GradientButtonView(icon: "arrow.backward", title:  "Back Button") {
                    viewModel.resetGame()
                }
                
                GradientButtonView(icon: "arrow.clockwise", title: "Try Again Button") {
                    viewModel.tryAgainWithSameCountry()
                }
            }
        }
    }

    func matchupView(champion: Food, challenger: Food) -> some View {
        VStack(spacing: 16) {
            Text(LocalizedStringKey("Which Prefer"))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                FoodCardView(food: champion) {
                    viewModel.selectWinner(champion)
                }
                Text(LocalizedStringKey("Versus"))
                    .font(.largeTitle)
                FoodCardView(food: challenger) {
                    viewModel.selectWinner(challenger)
                }
            }
            .padding(.top)

            Text(LocalizedStringKey(String(format: String(localized: "Remaining Dishes Format"), viewModel.foodList.count + 1)))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
