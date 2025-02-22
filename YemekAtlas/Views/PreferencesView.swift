import SwiftUI

struct PreferencesView: View {
    @AppStorage("colorScheme") private var colorScheme: String = "system"
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    @Environment(\.locale) private var locale
    
    var body: some View {
        Form {
            Section {
                Text("Theme Selection")
                    .font(.headline)
                    .textCase(.none)
                
                HStack {
                    Text("System Default")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { colorScheme == "system" },
                        set: { if $0 { colorScheme = "system" } }
                    ))
                }
                
                HStack {
                    Text("Light Mode")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { colorScheme == "light" },
                        set: { if $0 { colorScheme = "light" } }
                    ))
                }
                
                HStack {
                    Text("Dark Mode")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { colorScheme == "dark" },
                        set: { if $0 { colorScheme = "dark" } }
                    ))
                }
            }
            
            Section {
                Text("Language")
                    .font(.headline)
                    .textCase(.none)
                
                Picker("Select Language", selection: $selectedLanguage) {
                    Text("English").tag("en")
                    Text("Turkish").tag("tr")
                }
            }
        }
        .navigationTitle("Preferences")
        .environment(\.locale, Locale(identifier: selectedLanguage))
        .onChange(of: selectedLanguage) { _ in
            updateLocale()
        }
    }
    
    private func updateLocale() {
        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
}

#Preview {
    PreferencesView()
}
