//
//  User.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 29.10.2024.
//

import Foundation

struct User: Codable{
    let id : String
    let name: String
    let email: String
    let joined: TimeInterval
    var lastLogin: TimeInterval?  

    
    
    
}
