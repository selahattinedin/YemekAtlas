import SwiftUI

struct FirstView: View {
    @Binding var showFirstView: Bool

    var body: some View {
        ZStack {
            Image("welcomeImage2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.6)) 
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome to YemekAtlas")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.bottom, 40)
                
                Button(action: {
                    showFirstView = false
                }) {
                    Text("Continue")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color("foodbackcolor"))
                        .cornerRadius(15)
                }
            }
        }
    }
}
