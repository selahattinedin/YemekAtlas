//
//  Ingredients.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 4.02.2025.
//

import Foundation
struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let category: String
}
