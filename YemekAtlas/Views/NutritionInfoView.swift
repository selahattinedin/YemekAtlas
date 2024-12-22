//
//  NutritionInfoView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 22.12.2024.
//

import SwiftUI

struct NutritionInfoView: View {
    let icon: String
    let color: Color
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NutritionInfoView(icon: "", color: Color.blue, label: "")
}
