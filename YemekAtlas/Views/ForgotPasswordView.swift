import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var isAlertPresented = false
    @State private var alertTitle: LocalizedStringKey = ""
    @State private var alertMessage: LocalizedStringKey = ""
    @State private var isConfirmationAlert = true // Controls which alert is shown
    
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
                    Text("Reset Your Password")
                        .font(.custom("Avenir-Black", size: 32))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("Enter your email address\nand a password reset link will be sent.")
                        .font(.custom("Avenir-Medium", size: 20))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 30)
                
                // Email Field
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.black)
                        TextField("Email", text: $viewModel.email)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(27.5)
                }
                .padding(.horizontal, 60)
                
                // Reset Password Button
                Button(action: {
                    alertTitle = "Confirmation"
                    alertMessage = "Are you sure you want to send a password reset link?"
                    isConfirmationAlert = true
                    isAlertPresented = true
                }) {
                    HStack(spacing: 15) {
                        Text("Reset Password")
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
            
            // Back button
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.white)
                            Text("Back")
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
                // Confirmation Alert
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton: .destructive(Text("Yes")) {
                        viewModel.resetPassword { success in
                            if success {
                                alertTitle = "Success!"
                                alertMessage = "A password reset link has been sent to your email."
                                isConfirmationAlert = false
                                // Show success alert after a short delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isAlertPresented = true
                                }
                            } else {
                                alertTitle = "Error"
                                alertMessage = "An error occurred. Please try again."
                                isConfirmationAlert = false
                                // Show error alert after a short delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isAlertPresented = true
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            } else {
                // Result Alert
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertTitle == "Success!" {
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
