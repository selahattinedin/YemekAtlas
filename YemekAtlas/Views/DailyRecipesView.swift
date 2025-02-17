import SwiftUI
import Lottie

struct DailyRecipeView: View {
    @StateObject private var viewModel = DailyRecipesViewViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Günün Tarifi")
                    .font(.title2.bold())
                    .foregroundStyle(Color("foodbackcolor"))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    LottieView(animationName: "Loading")
                        .frame(width: 150)
                        .scaleEffect(0.6)
                        .padding(.top, -550)
                }
                .frame(maxWidth: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                }
                .padding()
            } else if let recipe = viewModel.dailyRecipes.first {
                DailyRecipeCardView(recipe: recipe)
            }
            
            Spacer()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DailyRecipeView()
    }
}
