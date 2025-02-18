import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel: ProfileViewViewModel
    @State private var showingAlert = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let user = viewModel.user {
                    Form {
                        Section("Kişisel Bilgiler") {
                            HStack {
                                Text("Ad Soyad")
                                Spacer()
                                Text(user.name)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("E-posta")
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("Katılma Tarihi")
                                Spacer()
                                Text(Date(timeIntervalSince1970: user.joined)
                                    .formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.gray)
                            }
                            
                            if let lastLogin = user.lastLogin {
                                HStack {
                                    Text("Son Giriş")
                                    Spacer()
                                    Text(Date(timeIntervalSince1970: lastLogin)
                                        .formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section {
                            Button("Hesabımı Sil") {
                                showingAlert = true
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("foodbackcolor"))
                            .cornerRadius(8)
                        }
                    }
                    .alert("Hesabınızı Silmek Üzeresiniz", isPresented: $showingAlert) {
                        Button("İptal", role: .cancel) { }
                        Button("Sil", role: .destructive) {
                            viewModel.deleteUser { success in
                                if success {
                                    // Kullanıcı silindiğinde LoginView'a dön
                                    dismiss()
                                }
                            }
                        }
                    } message: {
                        Text("Bu işlem geri alınamaz. Emin misiniz?")
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Profil Bilgileri")
        }
        .onChange(of: viewModel.isLoggedOut) { newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

#Preview {
    let viewModel = ProfileViewViewModel()
    return UserProfileView(viewModel: viewModel)
}
