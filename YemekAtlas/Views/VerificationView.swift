import SwiftUI
import FirebaseAuth

struct VerificationView: View {
    @StateObject private var viewModel = VerificationViewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Image("welcomeImage2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.6))
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                Spacer()
                    .frame(height: 60)
                
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "envelope.badge")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Text("E-posta Doğrulama")
                        .font(.custom("Avenir-Black", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("Lütfen e-posta adresinize gönderilen\ndoğrulama bağlantısını onaylayın")
                        .font(.custom("Avenir-Medium", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 30)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.custom("Avenir-Medium", size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Doğrulama Durumu
                Text(viewModel.verificationStatus)
                    .font(.custom("Avenir-Medium", size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Kontrol Et Butonu
                Button(action: {
                    viewModel.checkVerificationStatus()
                }) {
                    HStack(spacing: 15) {
                        Text("Doğrulama Durumunu Kontrol Et")
                            .font(.custom("Avenir-Heavy", size: 18))
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(width: 280, height: 60)
                    .background(Color(red: 255/255, green: 99/255, blue: 71/255))
                    .cornerRadius(27.5)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 20)
                
                // Mail Tekrar Gönder Butonu
                Button(action: {
                    viewModel.resendVerificationEmail()
                }) {
                    Text("Doğrulama Mailini Tekrar Gönder")
                        .font(.custom("Avenir-Medium", size: 16))
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Çıkış Yap Butonu
                Button(action: {
                    viewModel.signOut()
                }) {
                    Text("Çıkış Yap")
                        .font(.custom("Avenir-Medium", size: 16))
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startVerificationCheck()
        }
        .fullScreenCover(isPresented: $viewModel.shouldNavigateToLogin) {
            NavigationStack {
                WelcomeView()
            }
        }
    }
}


#Preview {
    VerificationView()
}
