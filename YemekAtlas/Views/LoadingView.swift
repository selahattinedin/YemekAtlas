//
//  LoadingView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 21.01.2025.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 10) {
            LottieView(animationName: "Loading", loopMode: .loop)
                .frame(width: 10, height: 10)

            Text("Tarifler Hazırlanıyor...")
                .font(.system(size: 40, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.top, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
       
        .padding(.horizontal)
    }
       
        
}

#Preview {
    LoadingView()
}
