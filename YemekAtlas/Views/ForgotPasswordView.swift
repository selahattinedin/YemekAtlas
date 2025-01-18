//
//  ForgotPasswordView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.01.2025.
//

import SwiftUI
import FirebaseAuth


import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewViewModel() // ViewModel
    @Environment(\.dismiss) private var dismiss // Modal'ı kapatmak için
    
    @State private var isAlertPresented = false // Alert'in gösterilip gösterilmeyeceğini kontrol eder
    @State private var alertTitle = "" // Alert başlığı
    @State private var alertMessage = "" // Alert mesajı
    @State private var isSuccessAlert = false // Success mesajı için boolean

    var body: some View {
        ZStack {
            Image("welcomeImage2") // Giriş ekranındaki arka plan resmi
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.6)) // Yarı şeffaf siyah overlay
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
                    isAlertPresented.toggle() // Alert'i göster
                }) {
                    HStack(spacing: 15) {
                        Text("Şifreyi Sıfırla")
                            .font(.custom("Avenir-Heavy", size: 20))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(width: 280, height: 70)
                    .background(Color(red: 255/255, green: 99/255, blue: 71/255)) // Turuncu arka plan
                    .cornerRadius(27.5)
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                }
                .padding(.top, 30)
                
                Spacer()
            }
            
            // Geri butonu - Sol üstte ve turuncu tasarım
            VStack {
                HStack {
                    Button(action: {
                        dismiss() // Modal'ı kapat
                    }) {
                        HStack {
                            Image(systemName: "chevron.left") // Geri ok simgesi
                                .font(.title3)
                                .foregroundColor(.white)
                            Text("Geri")
                                .font(.custom("Avenir-Medium", size: 16))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(red: 255/255, green: 99/255, blue: 71/255)) // Turuncu arka plan
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                    }
                    .padding(.top, 40) // Sol üstte konumlandırmak için üstten padding ekledik
                    .padding(.leading, 60) // Sol taraftan padding ile köşeye yapıştırdık
                    
                    Spacer()
                }
                Spacer()
            }
            
        }
        .navigationBarHidden(true)
        .alert(isPresented: $isAlertPresented) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                primaryButton: .destructive(Text("Evet")) {
                    viewModel.resetPassword { success in
                        if success {
                            alertTitle = "Başarılı!"
                            alertMessage = "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi."
                            isSuccessAlert = true
                        }
                    }
                },
                secondaryButton: .cancel(Text("Hayır"))
            )
        }
        .alert(isPresented: $isSuccessAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Tamam"), action: {
                    dismiss() // Modal'ı kapat
                })
            )
        }
    }
}




#Preview {
    ForgotPasswordView()
}
