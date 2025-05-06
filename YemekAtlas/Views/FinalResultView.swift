import SwiftUI

struct FinalResultView: View {
    @ObservedObject var viewModel: FoodGameViewViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(LocalizedStringKey("Congratulations"))
                .font(.largeTitle.bold())
                .foregroundColor(.green)

            Text(LocalizedStringKey("Favorite Dish"))
                .font(.title2)
                .foregroundColor(.primary)

            if let winner = viewModel.finalWinner, let country = viewModel.selectedCountry {
                ZStack {
                    Image("welcomeImage2")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 260)
                        .clipped()
                        .cornerRadius(20)
                        .overlay(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .cornerRadius(20)
                        )
                        .shadow(radius: 4)

                    VStack(spacing: 12) {
                        Text(country.flag)
                            .font(.system(size: 36))
                        
                        Text(winner.name)
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .multilineTextAlignment(.center)
                        
                        Text(winner.description)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(radius: 2)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(16)
                }
                .frame(height: 260)
                .padding(.horizontal)
            }

            HStack(spacing: 16) {
                GradientButtonView(icon: "arrow.counterclockwise", title: "Play Again") {
                    viewModel.restartGameWithSameCountry() 
                }
                
                GradientButtonView(icon: "flag", title: "New Country") {
                    viewModel.resetGame()
                }
            }
        }
        .padding()
    }
}
