//
//  ProfileView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import SwiftUI

struct ProfileView: View {
    let gridItems:[GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
        
    
    var body: some View {
        VStack(){
            

            HStack{
                Image("Ben")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                Spacer()
                
                HStack(spacing: 8){
                    VStack{
                        Text("10")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Posts")
                            .font(.subheadline)
                            .frame(width: 76)
                    }
                    VStack{
                        Text("10")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Takipçi")
                            .font(.subheadline)
                            .frame(width: 76)
                        
                        
                    }
                    VStack{
                        Text("10")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("Takip")
                            .font(.subheadline)
                            .frame(width: 76)
                        
                        
                    }
                }
                
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 4){
                Text("Selahattin Edin")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
               }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Button{}label: {
                Text("Profili Düzenle")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 365, height: 32)
                    .foregroundStyle(.black)
                    .overlay {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.pink, lineWidth: 1)
                    }
            }
            Divider()
                
            }
        LazyVGrid(columns: gridItems, spacing: 1){
            ForEach(0...10, id:\.self) { index in
                Image("steak")
                    .resizable()
                    .scaledToFill()
                
            }
        }
        
        }
    }


#Preview {
    ProfileView()
}
