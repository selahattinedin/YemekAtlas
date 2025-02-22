import SwiftUI
import FirebaseAuth

struct SettingsView: View {
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
                            title: "User Information",
                            icon: "person.fill",
                            description: viewModel.user?.name ?? "Loading...",
                            color: .blue
                        )
                    }
                    
                   
                    NavigationLink {
                        PreferencesView()
                    } label: {
                        SettingsCardView(
                            title: "Preferences",
                            icon: "gear",
                            description: "Theme, Language, Notifications",
                            color: .purple
                        )
                    }
                    
                    SettingsCardView(
                        title: "Security",
                        icon: "lock.fill",
                        description: "Password, Security Settings",
                        color: .green
                    )
                    
                    SettingsCardView(
                        title: "Help",
                        icon: "questionmark.circle.fill",
                        description: "FAQ, Contact",
                        color: .orange
                    )
                    
                    SettingsCardView(
                        title: "About",
                        icon: "info.circle.fill",
                        description: "App Information",
                        color: .gray
                    )
                    
                    // Logout Button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
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
            .navigationTitle("Settings")
            .navigationDestination(isPresented: $isLoggedOut) {
                LoginView()
            }
            .overlay(
                CustomAlertView(
                    title: "Log Out",
                    message: "Are you sure you want to log out of your account?",
                    confirmButtonTitle: "Log Out",
                    cancelButtonTitle: "Cancel",
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
