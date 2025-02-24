//
//  LocaleManager.swift
//  YemekAtlas
//
//  Created by Selahattin EDİN on 24.02.2025.
//

import Foundation


class LocaleManager: ObservableObject {
    static let shared = LocaleManager()

    @Published var locale: Locale

    private init() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        self.locale = Locale(identifier: savedLanguage)
    }

    func setLocale(identifier: String) {
        objectWillChange.send() // SwiftUI'yi değişiklik hakkında bilgilendir
        locale = Locale(identifier: identifier)
        UserDefaults.standard.set(identifier, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize() // Eski iOS sürümleri için gerekebilir
    }
}
