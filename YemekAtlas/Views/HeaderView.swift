//
//  HeaderView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 20.10.2024.
//

import SwiftUI

struct HeaderView: View {
    
    var body: some View {
        VStack {
            
            Image("logo")
                .resizable()
                .frame(width: 100,height: 100)
                .clipShape(Circle())
            
            Text("Hoşgeldiniz")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Giriş yapmak için devam edin")
                .foregroundColor(.gray)
                .padding(.bottom, 30)
        }
    }
}

#Preview {
    HeaderView()
}
