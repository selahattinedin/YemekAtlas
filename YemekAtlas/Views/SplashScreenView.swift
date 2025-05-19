import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Image("welcomeImage2")
                .resizable()
                .scaledToFill()
                .edgelessFrame()
                .blur(radius: 5)
                .overlay(
                    Color.black.opacity(0.3)
                        .edgelessFrame()
                )
        }
    }
}

extension View {
    func edgelessFrame() -> some View {
        self
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
