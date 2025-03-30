import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var authViewModel: AuthViewViewModel
    @EnvironmentObject private var appState: AppState
    @State private var showDeleteAccountAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    NavigationLink {
                        PreferencesView()
                    } label: {
                        SettingsCardView(
                            titleKey: "preferences",
                            description: "theme_language_notifications",
                            icon: "gear",
                            color: .purple
                        )
                    }
                    
                    // Security kartını sadece normal kullanıcılar görsün
                    if !authViewModel.isAnonymous {
                        SettingsCardView(
                            titleKey: "security",
                            description: "password_security_settings",
                            icon: "lock.fill",
                            color: .green
                        )
                    }
                    
                    SettingsCardView(
                        titleKey: "help",
                        description: "faq_contact",
                        icon: "questionmark.circle.fill",
                        color: .orange
                    )
                    
                    SettingsCardView(
                        titleKey: "about",
                        description: "app_information",
                        icon: "info.circle.fill",
                        color: .gray
                    )
                    
                    // Hesabı Sil Butonu
                    Button {
                        showDeleteAccountAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("delete_account")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle(localeManager.localizedString(forKey: "Settings"))
            .overlay(
                CustomAlertView(
                    title: "delete_account",
                    message: "delete_account_confirmation",
                    confirmButtonTitle: "delete",
                    cancelButtonTitle: "cancel",
                    confirmAction: {
                        authViewModel.deleteUser { success in
                            if success {
                                // AppState will be reset in the deleteUser method
                                // No need for navigation code here
                            }
                        }
                    },
                    cancelAction: {
                        showDeleteAccountAlert = false
                    },
                    isPresented: $showDeleteAccountAlert
                )
            )
        }
    }
}
