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
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.yellow)
                .frame(width: 70, height: 90)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .frame(width: 60, height: 75)
            
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(.black)
                    .font(.title2)
                
                if !text.isEmpty {
                    Text(text)
                        .fontWeight(.bold)
                        .font(.footnote)
                }
                Text(subtext)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
