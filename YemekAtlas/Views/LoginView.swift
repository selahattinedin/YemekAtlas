//
//  Selahattin Edin
//  YemekAtlas
//
//  Created by Selahattin EDİN on 20.10.2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header Section with Logo
                        VStack(spacing: 12) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.pink.opacity(0.2), lineWidth: 4)
                                )
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                .padding(.bottom, 10)
                            
                            Text("Tekrar Hoşgeldiniz!")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Devam etmek için giriş yapın")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                        
                        // Error Message
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .transition(.opacity)
                        }
                        
                        // Login Form
                        VStack(spacing: 20) {
                            // Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "envelope.fill")
                                        .foregroundColor(.pink)
                                    TextField("E-posta", text: $viewModel.email)
                                        .textInputAutocapitalization(.none)
                                        .autocorrectionDisabled()
                                        .keyboardType(.emailAddress)
                                }
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                                )
                            }
                            
                            // Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.pink)
                                    if viewModel.isPasswordVisible {
                                        TextField("Şifre", text: $viewModel.password)
                                    } else {
                                        SecureField("Şifre", text: $viewModel.password)
                                    }
                                    Button(action: {
                                        withAnimation {
                                            viewModel.isPasswordVisible.toggle()
                                        }
                                    }) {
                                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.pink)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 25)
                        
                        // Forgot Password
                        NavigationLink(destination: RegisterView()) {
                            Text("Şifremi Unuttum")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                                .fontWeight(.medium)
                        }
                        .padding(.top, 5)
                        
                        // Login Button
                        Button(action: {
                            withAnimation {
                                viewModel.login()
                            }
                        }) {
                            Text("Giriş Yap")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.pink, Color.pink.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .shadow(color: Color.pink.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 30)
                        
                        // Sign Up Link
                        HStack(spacing: 5) {
                            Text("Hesabınız yok mu?")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                            NavigationLink(destination: RegisterView()) {
                                Text("Kayıt Ol")
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .foregroundColor(.pink)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
    #Preview {
    LoginView()
}
                        
                    
