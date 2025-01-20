//
//  SwiftUIView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 19.10.2024.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        ZStack {
            // Arka plan resmi
            Image("welcomeImage2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Color.black.opacity(0.6)) // Siyah overlay
                .ignoresSafeArea()
            
        }
    }
}

#Preview {
    FirstView()
}
