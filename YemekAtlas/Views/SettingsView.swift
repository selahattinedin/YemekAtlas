import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @ObservedObject private var localeManager = LocaleManager.shared
    @StateObject private var viewModel = ProfileViewViewModel()
    @State private var showLogoutAlert = false
    @State private var isLoggedOut = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // User Information Card
                    NavigationLink {
                        UserProfileView(viewModel: viewModel)
                    } label: {
                        SettingsCardView(
                            titleKey: "user_information", // Yerelleştirilmiş anahtar
                            description: "personal_information", // Dinamik veri
                            icon: "person.fill",
                            color: .blue
                        )
                    }
                    
                    NavigationLink {
                        PreferencesView()
                    } label: {
                        SettingsCardView(
                            titleKey: "preferences",
                            description: "theme_language_notifications", // Yerelleştirilmiş anahtar
                            icon: "gear",
                            color: .purple
                        )
                    }
                    
                    SettingsCardView(
                        titleKey: "security",
                        description: "password_security_settings", // Yerelleştirilmiş anahtar
                        icon: "lock.fill",
                        color: .green
                    )
                    
                    SettingsCardView(
                        titleKey: "help",
                        description: "faq_contact", // Yerelleştirilmiş anahtar
                        icon: "questionmark.circle.fill",
                        color: .orange
                    )
                    
                    SettingsCardView(
                        titleKey: "about",
                        description: "app_information", // Yerelleştirilmiş anahtar
                        icon: "info.circle.fill",
                        color: .gray
                    )
                    
                    // Logout Button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("log_out") // Yerelleştirilmiş metin
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("foodbackcolor"))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle(localeManager.localizedString(forKey: "Settings"))
  // Yerelleştirilmiş metin
            .navigationDestination(isPresented: $isLoggedOut) {
                LoginView()
            }
            .overlay(
                CustomAlertView(
                    title: "log_out",  // Yerelleştirilmiş metin
                    message: "log_out_confirmation",  // Yerelleştirilmiş metin
                    confirmButtonTitle: "log_out",  // Yerelleştirilmiş metin
                    cancelButtonTitle: "cancel",  // Yerelleştirilmiş metin
                    confirmAction: {
                        viewModel.logout { success in
                            if success {
                                isLoggedOut = true
                            }
                        }
                    },
                    cancelAction: {
                        showLogoutAlert = false
                    },
                    isPresented: $showLogoutAlert
                )
            )
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
