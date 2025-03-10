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
            
            
            HStack(spacing: 12) {
             
                GradientButtonView(
                    icon: "globe",
                    title: LocalizedStringKey("English"),
                    startColor: selectedLanguage == "en" ? .orange : .indigo.opacity(0.2),
                    endColor: selectedLanguage == "en" ? .red : .purple.opacity(0.1),
                    action: {
                        selectedLanguage = "en"
                        localeManager.setLocale(identifier: "en")
                    }
                )
                .scaleEffect(selectedLanguage == "en" ? 1.05 : 1.0)
                .shadow(color: selectedLanguage == "en" ? .orange.opacity(0.3) : .clear, radius: 3)
                
                GradientButtonView(
                    icon: "globe",
                    title: LocalizedStringKey("Turkish"),
                    startColor: selectedLanguage == "tr" ? .orange : .indigo.opacity(0.2),
                    endColor: selectedLanguage == "tr" ? .red : .purple.opacity(0.1),
                    action: {
                        selectedLanguage = "tr"
                        localeManager.setLocale(identifier: "tr")
                    }
                )
                .scaleEffect(selectedLanguage == "tr" ? 1.05 : 1.0)
                .shadow(color: selectedLanguage == "tr" ? .orange.opacity(0.3) : .clear, radius: 3)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle(localeManager.localizedString(forKey: "Preferences"))
        .environment(\.locale, localeManager.locale) 
    }
}

#Preview {
    PreferencesView()
}
