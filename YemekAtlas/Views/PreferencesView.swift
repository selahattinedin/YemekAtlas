import SwiftUI

struct PreferencesView: View {
    @AppStorage("colorScheme") private var colorScheme: String = "system"
    
    var body: some View {
        Form {
            Section(header: Text("Tema Seçimi")) {
                Toggle("Sistem Varsayılanı", isOn: Binding(
                    get: { colorScheme == "system" },
                    set: { if $0 { colorScheme = "system" } }
                ))
                
                Toggle("Açık Mod", isOn: Binding(
                    get: { colorScheme == "light" },
                    set: { if $0 { colorScheme = "light" } }
                ))
                
                Toggle("Karanlık Mod", isOn: Binding(
                    get: { colorScheme == "dark" },
                    set: { if $0 { colorScheme = "dark" } }
                ))
            }
        }
        .navigationTitle("Tercihler")
    }
}

#Preview {
    PreferencesView()
}
