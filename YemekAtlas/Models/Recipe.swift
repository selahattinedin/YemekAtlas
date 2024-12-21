//
//  Recipe.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

struct Recipe: Codable {
    let name: String
    let ingredients: [String]
    let calories: Int
    let protein: Int
    let carbohydrates: Int
    let fat: Int
    let allergens: [String]
    let instructions: String
    let imageURL: String
}

