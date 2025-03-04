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
        // Get the preferred language from the system
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        
        // Check if we have a saved language preference
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            // Use the saved preference if available
            self.locale = Locale(identifier: savedLanguage)
        } else {
            // Otherwise use the system language (limited to supported languages)
            let languageCode = preferredLanguage.prefix(2)
            // Check if the language is supported, otherwise default to English
            let supportedLanguage = (languageCode == "tr") ? "tr" : "en"
            self.locale = Locale(identifier: supportedLanguage)
            
            // Save this initial value
            UserDefaults.standard.set(supportedLanguage, forKey: "selectedLanguage")
        }
    }
    
    func setLocale(identifier: String) {
        objectWillChange.send() // SwiftUI'yi değişiklik hakkında bilgilendir
        locale = Locale(identifier: identifier)
        UserDefaults.standard.set(identifier, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize() // Eski iOS sürümleri için gerekebilir
    }
    
    // Get localized string respecting the app's language setting
    func localizedString(forKey key: String, comment: String = "") -> String {
        if let path = Bundle.main.path(forResource: locale.identifier.prefix(2) == "tr" ? "tr" : "en", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: key, value: key, table: nil)
        }
        
        // Fallback to system localization if specific bundle not found
        return NSLocalizedString(key, comment: comment)
    }
    
    // Format localized string with parameters
    func localizedStringWithFormat(forKey key: String, _ args: CVarArg...) -> String {
        let format = localizedString(forKey: key)
        return String(format: format, arguments: args)
    }
    
    // Helper property to get current language code
    var currentLanguageCode: String {
        return locale.identifier.prefix(2) == "tr" ? "tr" : "en"
    }
}
