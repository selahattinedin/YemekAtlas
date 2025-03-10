import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @State private var isPasswordVisible = false
    @State private var showForgotPasswordModal = false // Show modal

    var body: some View {
        ZStack {
            Image("welcomeImage2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.6))
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Header
                    VStack(spacing: 12) {
                        Text("Welcome!")
                            .font(.custom("Avenir-Black", size: 32))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        Text("Continue your kitchen journey!")
                            .font(.custom("Avenir-Medium", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, 30)
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        // Email Field
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
                        
                        // Password Field with Toggle
                        HStack(spacing: 15) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.black)
                            if isPasswordVisible {
                                TextField("Password", text: $viewModel.password)
                                    .foregroundColor(.black)
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .foregroundColor(.black)
                            }
                            Button(action: {
                                withAnimation {
                                    isPasswordVisible.toggle()
                                }
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.black)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(27.5)
                    }
                    .padding(.horizontal, 45)
                    
                    // Forgot Password Button (opens modal)
                    Button(action: {
                        showForgotPasswordModal.toggle() // Show modal
                    }) {
                        Text("Forgot Password")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.custom("Avenir-Medium", size: 20))
                    }
                    .padding(.top, 10)
                    
                    // Login Button
                    Button(action: {
                        viewModel.login()
                    }) {
                        HStack(spacing: 15) {
                            Text("Login")
                                .font(.custom("Avenir-Heavy", size: 20))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: 280, height: 70)
                        .background(Color("foodbackcolor"))
                        .cornerRadius(27.5)
                        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                    }
                    .padding(.top, 30)
                    
                    // Register Link
                    HStack(spacing: 5) {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        NavigationLink(destination: RegisterView()) {
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(Color("foodbackcolor"))
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showForgotPasswordModal) {
            ForgotPasswordView() // Modal view
        }
    }
}

#Preview {
    LoginView()
}
