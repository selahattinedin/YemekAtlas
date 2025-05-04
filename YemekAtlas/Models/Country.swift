//
//  Country.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 4.05.2025.
//

import Foundation

struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let flag: String
    
    static let popularCountries = [
        Country(name: "Türkiye", flag: "🇹🇷"),
        Country(name: "Italy", flag: "🇮🇹"),
        Country(name: "Japan", flag: "🇯🇵"),
        Country(name: "Mexico", flag: "🇲🇽"),
        Country(name: "India", flag: "🇮🇳"),
        Country(name: "France", flag: "🇫🇷"),
        Country(name: "China", flag: "🇨🇳"),
        Country(name: "Greece", flag: "🇬🇷"),
        Country(name: "Thailand", flag: "🇹🇭"),
        Country(name: "USA", flag: "🇺🇸")
    ]
}
