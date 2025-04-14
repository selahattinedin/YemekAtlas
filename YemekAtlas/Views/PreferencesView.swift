import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @State private var selectedLanguage: String
    @State private var viewRefreshTrigger = false // Sadece bu view'i yenilemek için
    
    init() {
        _selectedLanguage = State(initialValue: LocaleManager.shared.locale.identifier)
    }
    
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
                        withAnimation {
                            selectedLanguage = "en"
                            localeManager.setLocale(identifier: "en")
                            // Sadece bu view'ı yenile, tüm uygulamayı değil
                            viewRefreshTrigger.toggle()
                        }
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
                        withAnimation {
                            selectedLanguage = "tr"
                            localeManager.setLocale(identifier: "tr")
                            // Sadece bu view'ı yenile, tüm uygulamayı değil
                            viewRefreshTrigger.toggle()
                        }
                    }
                )
                .scaleEffect(selectedLanguage == "tr" ? 1.05 : 1.0)
                .shadow(color: selectedLanguage == "tr" ? .orange.opacity(0.3) : .clear, radius: 3)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .id(viewRefreshTrigger) // Sadece bu view'ı yenilemek için ID kullanıyoruz
        .padding(.top)
        .navigationTitle(localeManager.localizedString(forKey: "Preferences"))
        .environment(\.locale, localeManager.locale)
    }

}

#Preview {
    PreferencesView()
}
