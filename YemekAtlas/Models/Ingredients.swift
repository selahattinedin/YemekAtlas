import Foundation
import SwiftUI

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String 
    let imageUrl: String
    let category: String
    var imageStorageUrl: String?
}
