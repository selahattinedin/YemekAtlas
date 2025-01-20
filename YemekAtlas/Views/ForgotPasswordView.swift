import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAlertPresented = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isConfirmationAlert = true // Hangi alert'in gösterileceğini kontrol eder
    
    var body: some View {
        ZStack {
            Image("welcomeImage2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.6))
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Header
                VStack(spacing: 12) {
                    Text("Şifrenizi Sıfırlayın")
                        .font(.custom("Avenir-Black", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("E-posta adresinizi girin\nşifre sıfırlama bağlantısı gönderilecek.")
                        .font(.custom("Avenir-Medium", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 30)
                
                // E-posta Field
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.black)
                        TextField("E-posta", text: $viewModel.email)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(27.5)
                }
                .padding(.horizontal, 60)
                
                // Şifreyi Sıfırla Button
                Button(action: {
                    alertTitle = "Onay"
                    alertMessage = "Şifre sıfırlama bağlantısı göndermek istediğinize emin misiniz?"
                    isConfirmationAlert = true
                    isAlertPresented = true
                }) {
                    HStack(spacing: 15) {
                        Text("Şifreyi Sıfırla")
                            .font(.custom("Avenir-Heavy", size: 20))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(width: 280, height: 70)
                    .background(Color(red: 255/255, green: 99/255, blue: 71/255))
                    .cornerRadius(27.5)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 30)
                
                Spacer()
            }
            
            // Geri butonu
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.white)
                            Text("Geri")
                                .font(.custom("Avenir-Medium", size: 16))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(red: 255/255, green: 99/255, blue: 71/255))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                    .padding(.top, 40)
                    .padding(.leading, 60)
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $isAlertPresented) {
            if isConfirmationAlert {
                // Onay Alert'i
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton: .destructive(Text("Evet")) {
                        viewModel.resetPassword { success in
                            if success {
                                alertTitle = "Başarılı!"
                                alertMessage = "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi."
                                isConfirmationAlert = false
                                // Kısa bir gecikme ile success alert'ini göster
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isAlertPresented = true
                                }
                            } else {
                                alertTitle = "Hata"
                                alertMessage = "Bir hata oluştu. Lütfen tekrar deneyin."
                                isConfirmationAlert = false
                                // Kısa bir gecikme ile error alert'ini göster
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isAlertPresented = true
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("Hayır"))
                )
            } else {
                // Sonuç Alert'i
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Tamam")) {
                        if alertTitle == "Başarılı!" {
                            dismiss()
                        }
                    }
                )
            }
        }
    }
}

#Preview{
    ForgotPasswordView()
}
