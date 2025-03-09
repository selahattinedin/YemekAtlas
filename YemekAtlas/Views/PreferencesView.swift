import SwiftUI

struct PreferencesView: View {
    @ObservedObject private var localeManager = LocaleManager.shared
    @State private var selectedLanguage: String = LocaleManager.shared.locale.identifier
    
    var body: some View {
        VStack(spacing: 20) {
            Text(LocalizedStringKey("Language"))
                .font(.headline)
                .textCase(.none)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Language tab selection using GradientButtonView
            HStack(spacing: 12) {
                // English Tab
                GradientButtonView(
                    icon: "globe",
                    title: LocalizedStringKey("English"),
                    startColor: selectedLanguage == "en" ? .orange : .indigo.opacity(0.6),
                    endColor: selectedLanguage == "en" ? .red : .purple.opacity(0.4),
                    action: {
                        selectedLanguage = "en"
                        localeManager.setLocale(identifier: "en")
                    }
                )
                
                // Turkish Tab
                GradientButtonView(
                    icon: "globe",
                    title: LocalizedStringKey("Turkish"),
                    startColor: selectedLanguage == "tr" ? .orange : .indigo.opacity(0.6),
                    endColor: selectedLanguage == "tr" ? .red : .purple.opacity(0.4),
                    action: {
                        selectedLanguage = "tr"
                        localeManager.setLocale(identifier: "tr")
                    }
                )
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle(localeManager.localizedString(forKey: "Preferences"))
        .environment(\.locale, localeManager.locale) // Apply language change
    }
}



#Preview {
    PreferencesView()
}
