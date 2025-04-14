//
//  Food.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 14.04.2025.
//

import Foundation
struct Food: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let image: String
    let description: String
    
    static func == (lhs: Food, rhs: Food) -> Bool {
        return lhs.id == rhs.id
    }
}
