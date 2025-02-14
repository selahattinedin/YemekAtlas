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
                    // Kullanıcı Bilgileri Kartı
                    NavigationLink {
                        UserProfileView(viewModel: viewModel)
                    } label: {
                        SettingsCardView(
                            title: "Kullanıcı Bilgileri",
                            icon: "person.fill",
                            description: viewModel.user?.name ?? "Yükleniyor...",
                            color: .blue
                        )
                    }
                    
                    // Tercihler Sayfası
                    NavigationLink {
                        PreferencesView()
                    } label: {
                        SettingsCardView(
                            title: "Tercihler",
                            icon: "gear",
                            description: "Tema, Dil, Bildirimler",
                            color: .purple
                        )
                    }
                    
                    SettingsCardView(
                        title: "Güvenlik",
                        icon: "lock.fill",
                        description: "Şifre, Güvenlik Ayarları",
                        color: .green
                    )
                    
                    SettingsCardView(
                        title: "Yardım",
                        icon: "questionmark.circle.fill",
                        description: "SSS, İletişim",
                        color: .orange
                    )
                    
                    SettingsCardView(
                        title: "Hakkında",
                        icon: "info.circle.fill",
                        description: "Uygulama Bilgileri",
                        color: .gray
                    )
                    
                    // Çıkış Yap Butonu
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Çıkış Yap")
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
            .navigationTitle("Ayarlar")
            .navigationDestination(isPresented: $isLoggedOut) {
                LoginView()
            }
            .overlay(
                CustomAlertView(
                    title: "Çıkış Yap",
                    message: "Hesabınızdan çıkış yapmak istediğinize emin misiniz?",
                    confirmButtonTitle: "Çıkış Yap",
                    cancelButtonTitle: "İptal",
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
