//
//  Recipe.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import Foundation

struct Recipe: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let ingredients: [String]
    let calories: Int
    let protein: Int
    let carbohydrates: Int
    let fat: Int
    let allergens: [String]
    let instructions: String
    let imageURL: String
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
           lhs.id == rhs.id
       }
}
