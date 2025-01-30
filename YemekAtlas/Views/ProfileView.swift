import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewViewModel()
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false

    var user: User

    var body: some View {
        NavigationStack {
            VStack {
                // Profil Fotoğrafı
                Image(systemName: "person.crop.circle.fill") // Örnek, profil resmi eklenebilir
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.top, 150)

                // Kullanıcı adı ve e-posta
                VStack(alignment: .leading, spacing: 6) {
                    Text(user.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 36)
                .padding(.horizontal)
                Spacer()
                // Çıkış yapma butonu
                Button {
                    showLogoutAlert = true
                } label: {
                    Text("Çıkış Yap")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .frame(width: 365, height: 40)
                        .foregroundStyle(.white)
                        .background(Color("foodbackcolor"))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                }
                .padding(.bottom, 250)

            }
            
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .padding()

            // CustomAlertView çağrısı
            .overlay {
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
                    cancelAction: {},
                    isPresented: $showLogoutAlert
                )
            }
        }
        .navigationDestination(isPresented: $isLoggedOut) {
            LoginView() // Çıkış sonrası login ekranına yönlendir
        }
    }
}

#Preview {
    ProfileView(user: User(id: "123", name: "Selahattin Edin", email: "selahattin@edin.com", joined: Date().timeIntervalSince1970))
}
