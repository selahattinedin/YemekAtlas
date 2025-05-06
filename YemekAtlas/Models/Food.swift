import Foundation
import SwiftUI

struct Food: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let image: String
    
    // İki dilde açıklamaları saklıyoruz
    private let descriptionEN: String
    private let descriptionTR: String
    
    // Geçerli dile göre doğru açıklamayı döndüren hesaplanmış özellik
    var description: String {
        let languageCode = LocaleManager.shared.currentLanguageCode
        return languageCode == "tr" ? descriptionTR : descriptionEN
    }
    
    // Her iki dil için açıklamalarla başlatıcı
    init(name: String, image: String, descriptionEN: String, descriptionTR: String) {
        self.name = name
        self.image = image
        self.descriptionEN = descriptionEN
        self.descriptionTR = descriptionTR
    }
    
    // Geriye dönük uyumluluk için uygun başlatıcı
    init(name: String, image: String, description: String) {
        self.name = name
        self.image = image
        self.descriptionEN = description
        self.descriptionTR = description // Varsayılan olarak her iki dil için aynı açıklama
    }
    
    static func == (lhs: Food, rhs: Food) -> Bool {
        return lhs.id == rhs.id
    }
}
