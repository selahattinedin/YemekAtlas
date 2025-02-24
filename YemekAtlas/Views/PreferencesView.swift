import SwiftUI

struct PreferencesView: View {
    @AppStorage("colorScheme") private var colorScheme: String = "system"
    @ObservedObject private var localeManager = LocaleManager.shared

    var body: some View {
        Form {
            Section {
                Text(LocalizedStringKey("theme_selection"))
                    .font(.headline)
                    .textCase(.none)

                ToggleRow(title: LocalizedStringKey("system_default"), selected: $colorScheme, value: "system")
                ToggleRow(title: LocalizedStringKey("light_mode"), selected: $colorScheme, value: "light")
                ToggleRow(title: LocalizedStringKey("dark_mode"), selected: $colorScheme, value: "dark")
            }

            Section {
                Text(LocalizedStringKey("language"))
                    .font(.headline)
                    .textCase(.none)

                Picker(LocalizedStringKey("select_language"), selection: Binding(
                    get: { localeManager.locale.identifier },
                    set: { localeManager.setLocale(identifier: $0) }
                )) {
                    Text(LocalizedStringKey("english")).tag("en")
                    Text(LocalizedStringKey("turkish")).tag("tr")
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle(LocalizedStringKey("preferences"))
        .environment(\.locale, localeManager.locale) // Apply language change
    }
}

// Toggle için özel satır bileşeni
struct ToggleRow: View {
    let title: LocalizedStringKey
    @Binding var selected: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: Binding(
                get: { selected == value },
                set: { if $0 { selected = value } }
            ))
            .labelsHidden() // Toggle etiketini gizle
        }
    }
}
