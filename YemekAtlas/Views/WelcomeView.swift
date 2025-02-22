//
//  GettingStartedView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.01.2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var shouldNavigateToLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("welcomeImage2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Spacer()
                    Text("Discover Your Kitchen\nwith AI")
                        .font(.custom("Avenir-Black", size: 38))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("Explore the future of cooking\nwith personalized recipes\nand smart suggestions!")
                        .font(.custom("Avenir-Medium", size: 25))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 35)
                        .lineSpacing(4)
                    
                    Spacer()
                    
                    NavigationLink(destination: LoginView()) {
                        HStack(spacing: 15) {
                            Text("Discover the Taste")
                                .font(.custom("Avenir-Heavy", size: 20))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 20, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: 280, height: 70)
                        .background(Color(red: 255/255, green: 99/255, blue: 71/255))
                        .cornerRadius(27.5)
                        .padding(.horizontal, 40)
                        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
