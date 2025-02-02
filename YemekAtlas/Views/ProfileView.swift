import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewViewModel()
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color("foodbackcolor").opacity(0.9),
                    Color("foodbackcolor").opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            } else if let user = viewModel.user {
                // Glass effect card
                VStack {
                    Spacer()
                    
                    VStack(spacing: 25) {
                        // Profile image
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.15))
                                .frame(width: 130, height: 130)
                                .blur(radius: 10)
                            
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 110)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 20)
                        
                        // User info with glass effect
                        VStack(spacing: 15) {
                            Text(user.name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(user.email)
                                .font(.system(size: 17))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Katılma Tarihi: \(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // Stylish logout button
                        Button {
                            showLogoutAlert = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Çıkış Yap")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color("foodbackcolor"))
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            )
                        }
                        .padding(.top, 30)
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.15))
                            .background(.ultraThinMaterial)
                            .blur(radius: 0)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            
           
        
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Profil")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        
        // Custom Alert
        .overlay {
            if showLogoutAlert {
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
            }
        }
        .navigationDestination(isPresented: $isLoggedOut) {
            LoginView()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
