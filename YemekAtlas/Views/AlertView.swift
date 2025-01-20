//
//  AlertView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 19.01.2025.
//

import SwiftUI

struct AlertView: View {
    let type: AlertType
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void
    @Binding var isPresented: Bool
    
    enum AlertType {
        case success
        case error
        case warning
        case info
        
        var color: Color {
            switch self {
            case .success: return Color.green
            case .error: return Color(red: 255/255, green: 99/255, blue: 71/255)
            case .warning: return Color.orange
            case .info: return Color.blue
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error: return "exclamationmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: type.icon)
                    .font(.system(size: 50))
                    .foregroundColor(type.color)
                
                Text(title)
                    .font(.custom("Avenir-Heavy", size: 20))
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(.custom("Avenir-Medium", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    withAnimation {
                        isPresented = false
                        action()
                    }
                }) {
                    Text(buttonTitle)
                        .font(.custom("Avenir-Heavy", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(type.color)
                        .cornerRadius(25)
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    AlertView(type:.success, title: "", message: "", buttonTitle: "", action: {}, isPresented: .constant(true))
}
