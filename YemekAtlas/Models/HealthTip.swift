//
//  HealthTip.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 1.12.2024.
//

import Foundation
struct HealthTip: Identifiable, Hashable {
    let id = UUID()
    let tip: String
    let category: String
    let icon: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
