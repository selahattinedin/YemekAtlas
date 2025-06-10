import Foundation
import SwiftUI

struct ChefSpecialImage {
    static let images: [String: String] = [
        "Pizza": "Pizza",
        "Sushi": "Sushi",
        "Hamburger": "Hamburger",
        "Tacos": "Tacos",
        "PadThai": "PadThai"
    ]
    
    static func getImage(for recipeName: String) -> String {
        return images[recipeName] ?? "default_food"
    }
} 