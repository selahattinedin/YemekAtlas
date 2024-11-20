//
//  Recipe.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 18.11.2024.
//

import Foundation
struct Recipe:Codable{
    
    let name: String
    let ingredients: [String]
    let calories: Int
    let allergens: [String]
    let instructions: String
    let imageURL: String
    
    
}
