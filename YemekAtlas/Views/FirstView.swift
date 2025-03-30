import SwiftUI

struct FirstView: View {
    @Binding var showFirstView: Bool
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var authViewModel: AuthViewViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Image("welcomeImage2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Rectangle()
                        .fill(Color.black.opacity(0.4))
                        .edgesIgnoringSafeArea(.all)
                )
            
            VStack(spacing: 25) {
                Spacer()
                Text("YemekAtlas")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                
                // Tagline
                Text("Discover the delicious world of Turkish cuisine")
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Spacer()
                
                // Modified GradientButtonView with proper width constraints
                Button {
                    authViewModel.signInAnonymously()
                    showFirstView = false
                    appState.isFirstLaunch = false
                    appState.isAuthenticated = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 22))
                        Text("Get Started")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(width: 220) // Fixed width for oval shape
                    .background(
                        LinearGradient(colors: [.orange, .red],
                                     startPoint: .leading,
                                     endPoint: .trailing)
                    )
                    .clipShape(Capsule()) // Perfectly oval shape
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .statusBar(hidden: true)
    }
}

struct FirstViewPreview: PreviewProvider {
    static var previews: some View {
        FirstView(showFirstView: .constant(true))
            .environmentObject(AppState.shared)
            .environmentObject(AuthViewViewModel.shared)
    }
}
