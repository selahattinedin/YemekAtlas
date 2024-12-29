//
//  TabButtonView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 29.12.2024.
//

import SwiftUI

struct TabButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color.clear)
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(20)
        }
    }
}
#Preview {
    TabButton(text: "", isSelected: true, action: {})
}
