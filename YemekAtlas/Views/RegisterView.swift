//
//  RegisterView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 19.10.2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
              
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                       
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
                            
                            Text("Hoşgeldiniz")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("Kayıt olmak için devam edin")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                        
                       
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundStyle(.red)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .transition(.opacity)
                        }
                        
                        // Registration Form
                        VStack(spacing: 20) {
                            // Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.pink)
                                    TextField("Tam isminizi giriniz", text: $viewModel.name)
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
                                    SecureField("Şifre", text: $viewModel.password)
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
                        
                        // Terms Agreement
                        HStack {
                            Button(action: {
                                viewModel.agreeToTerms.toggle()
                            }) {
                                Image(systemName: viewModel.agreeToTerms ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.agreeToTerms ? .pink : .gray)
                            }
                            
                            Text("Kabul ediyorum")
                                .foregroundColor(.gray)
                            
                            NavigationLink(destination: AgreementView()) {
                                Text("Kullanım Koşulları")
                                    .foregroundColor(.pink)
                            }
                        }
                        .padding(.top, 5)
                        
                        // Register Button
                        Button(action: {
                            withAnimation {
                                viewModel.register()
                            }
                        }) {
                            Text("Kayıt Ol")
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
                        
                        // Login Link
                        HStack(spacing: 5) {
                            Text("Zaten bir hesabın var mı?")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                            NavigationLink(destination: LoginView()) {
                                Text("Giriş Yap")
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
    RegisterView()
}
