//
//  GradientButtonView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 10.02.2025.
//

import SwiftUI
struct GradientButtonView: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [.orange, .red],
                             startPoint: .leading,
                             endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 27.5))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }
}
#Preview {
    GradientButtonView(icon: "", title: "", action: {})
}
