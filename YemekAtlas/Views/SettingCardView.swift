//
//  SettingCardView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 14.02.2025.
//

import SwiftUI

struct SettingsCardView: View {
    let title: String
    let icon: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}

#Preview {
    SettingsCardView(title: "", icon: "", description: "", color: .white)
}
