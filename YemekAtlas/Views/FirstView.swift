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
                Text("Discover delicious cuisines from around the world")
                    .font(.system(size: 17, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Spacer()
                
                GradientButtonView(
                    icon: "arrow.right.circle.fill",
                    title: "Get Started",
                    startColor: .orange,
                    endColor: .red
                ) {
                    authViewModel.signInAnonymously()
                    showFirstView = false
                    appState.isFirstLaunch = false
                    appState.isAuthenticated = true
                }
                .frame(width: 220) // Sabit genişlik için
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
