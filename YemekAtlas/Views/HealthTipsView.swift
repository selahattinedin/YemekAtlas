//
//  HealthTipsView.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 1.12.2024.
//

import SwiftUI

struct HealthTipsView: View {
    @StateObject private var viewModel = HealthTipsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Sağlıklı ipuçları")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await viewModel.fetchHealthTips()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .foregroundColor(.pink)
                            .font(.title2)
                    }
                }
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                } else {
                    ForEach(viewModel.healthTips) { tip in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: tip.icon)
                                .foregroundColor(.pink)
                                .font(.system(size: 20))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tip.tip)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Text(tip.category)
                                    .font(.caption)
                                    .foregroundColor(.pink)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.pink.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 5)
            )
            .padding()
            .onAppear {
                Task {
                    await viewModel.fetchHealthTips()
                }
            }
        }
    }
}

#Preview {
    HealthTipsView()
}

