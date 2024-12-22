//
//  SwiftUIView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 19.10.2024.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        VStack {
            Image("YemekAtlasIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .clipShape(Circle())

            Text("Yemek Atlası")
                .bold()
                .font(.largeTitle)
                .italic()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.1), Color(red: 0.2, green: 0.2, blue: 0.2)]), 
                           startPoint: .top, endPoint: .bottom)
        )
        .ignoresSafeArea()
    }
}

#Preview {
    FirstView()
}
