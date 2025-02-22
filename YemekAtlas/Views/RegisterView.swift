import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()

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
                        Text("Welcome to \nKitchen Journey!")
                            .font(.custom("Avenir-Black", size: 32))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                        Text("Create your account and\nexplore the kitchen!")
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
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        // Name Field
                        HStack(spacing: 15) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                            TextField("Full Name", text: $viewModel.name)
                                .foregroundColor(.black)
                                .autocapitalization(.words)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(27.5)
                        
                        // Email Field
                        HStack(spacing: 15) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.black)
                            TextField("Email", text: $viewModel.email)
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .keyboardType(.emailAddress)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(27.5)
                        
                        // Password Field
                        HStack(spacing: 15) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.black)
                            SecureField("Password", text: $viewModel.password)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(27.5)
                        
                        // Terms and Conditions Checkbox
                        HStack(spacing: 8) {
                            Button(action: {
                                viewModel.agreeToTerms.toggle()
                            }) {
                                Image(systemName: viewModel.agreeToTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(viewModel.agreeToTerms ? Color(red: 255/255, green: 99/255, blue: 71/255) : .white)
                                    .font(.system(size: 20))
                            }
                            
                            Text("I accept the terms and conditions")
                                .font(.custom("Avenir-Medium", size: 14))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 50)
                    
                    // Register Button
                    Button(action: {
                        viewModel.register()
                    }) {
                        HStack(spacing: 15) {
                            Text("Sign Up")
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
                    
                    NavigationLink(destination: VerificationView(), isActive: $viewModel.showVerificationScreen) {
                        EmptyView()
                    }
                    .isDetailLink(false)
                }
            }
        }
    }
}
