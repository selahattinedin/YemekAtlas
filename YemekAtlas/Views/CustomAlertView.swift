//
//  CustomAlertView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 4.01.2025.
//

import SwiftUI

struct CustomAlertView: View {
    let title: String
    let message: String
    let confirmButtonTitle: String
    let cancelButtonTitle: String
    let confirmAction: () -> Void
    let cancelAction: () -> Void

    @Binding var isPresented: Bool

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4) 
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)

                    Text(message)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    HStack(spacing: 16) {
                        Button(cancelButtonTitle) {
                            cancelAction()
                            isPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        Button(confirmButtonTitle) {
                            confirmAction()
                            isPresented = false
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    @State var isPresented = true
    return CustomAlertView(
        title: "Çıkış Yap",
        message: "Hesabınızdan çıkış yapmak istediğinize emin misiniz?",
        confirmButtonTitle: "Çıkış Yap",
        cancelButtonTitle: "İptal",
        confirmAction: {
            print("Çıkış yapıldı.")
        },
        cancelAction: {
            print("İptal edildi.")
        },
        isPresented: $isPresented
    )
}
