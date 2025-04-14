import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 5) {
                
                    LottieView(animationName: "Food", loopMode: .loop)
                    .frame(width: 200)
                    
                Text(LocalizedStringKey("Preparing for..."))
                    .font(.title)
                    .foregroundColor(.primary)
                    .padding(.bottom, 120)
                
            }
            .padding(15)
            
            
        }
    }
}


#Preview {
    LoadingView()
}
