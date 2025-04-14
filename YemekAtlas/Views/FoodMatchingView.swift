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
                    if viewModel.matchingComplete {
                        finalResultView
                    } else if let champion = viewModel.currentChampion, let challenger = viewModel.currentChallenger {
                        matchupView(champion: champion, challenger: challenger)
                    } else {
                        introView
                    }
                }
                .padding()
                .navigationTitle("🍽️ Yemek Eşleştirme")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    var introView: some View {
        VStack(spacing: 30) {
            Text("Favori Yemeğini Bul!")
                .font(.largeTitle.bold())
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("Her seçimde kazanan yemek kalacak,\nyeni rakiple tekrar eşleşecek.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            GradientButtonView(icon: "play.fill", title: "Başla") {
                viewModel.startGame()
            }
        }
    }


    func matchupView(champion: Food, challenger: Food) -> some View {
        VStack(spacing: 16) {
            Text("Hangisini tercih edersin?")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                FoodCardView(food: champion) {
                    viewModel.selectWinner(champion)
                }
                Text("🆚")
                    .font(.largeTitle)
                FoodCardView(food: challenger) {
                    viewModel.selectWinner(challenger)
                }
            }
            .padding(.top)

            Text("Kalan yemek sayısı: \(viewModel.foodList.count + 1)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

   var finalResultView: some View {
        VStack(spacing: 24) {
            Text("🎉 Tebrikler!")
                .font(.largeTitle.bold())
                .foregroundColor(.green)

            Text("Favori yemeğin:")
                .font(.title2)
                .foregroundColor(.primary)

            if let winner = viewModel.finalWinner {
                ZStack {
                    Image(winner.image)
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
                        .shadow(radius: 8)

                    Text(winner.name)
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
                .frame(height: 260)
                .padding(.horizontal)
            }

            GradientButtonView(icon: "arrow.counterclockwise", title: "Tekrar Oyna") {
                viewModel.resetGame()
            }
        }
        .padding()
    }

}



struct FoodCardView: View {
    let food: Food
    let action: () -> Void

    var body: some View {
        ZStack {
            Image(food.image)
                .resizable()
                .scaledToFill()
                .frame(width: 160, height: 220)
                .clipped()
                .overlay(Color.black.opacity(0.3))

            VStack(spacing: 8) {
                Text(food.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(radius: 4)

                Text(food.description)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 8)
                    .shadow(radius: 2)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.25))
            .cornerRadius(12)
            .padding(.bottom, 10)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .background(
            Image("default_food_bg")
                .resizable()
                .scaledToFill()
        )
        .cornerRadius(16)
        .frame(width: 160, height: 220)
        .shadow(color: .gray.opacity(0.4), radius: 6, x: 0, y: 4)
        .onTapGesture {
            action()
        }
    }
}
