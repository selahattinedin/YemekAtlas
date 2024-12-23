//
//  InfoPill.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 23.12.2024.
//

import SwiftUI

struct InfoPill: View {
    let icon: String
    let text: String
    let subtext: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.black)
            if !text.isEmpty {
                Text(text)
                    .fontWeight(.bold)
            }
            Text(subtext)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.pink.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    InfoPill(icon: "", text: "", subtext: "")
}
