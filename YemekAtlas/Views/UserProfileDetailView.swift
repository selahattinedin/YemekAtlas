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
                        Section(LocalizedStringKey("personal_information")) {
                            HStack {
                                Text(LocalizedStringKey("full_name"))
                                Spacer()
                                Text(user.name)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text(LocalizedStringKey("email"))
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text(LocalizedStringKey("join_date"))
                                Spacer()
                                Text(Date(timeIntervalSince1970: user.joined)
                                    .formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.gray)
                            }
                            
                            if let lastLogin = user.lastLogin {
                                HStack {
                                    Text(LocalizedStringKey("last_login"))
                                    Spacer()
                                    Text(Date(timeIntervalSince1970: lastLogin)
                                        .formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section {
                            Button(LocalizedStringKey("delete_my_account")) {
                                showingAlert = true
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("foodbackcolor"))
                            .cornerRadius(8)
                        }
                    }
                    .alert(LocalizedStringKey("delete_account_alert"), isPresented: $showingAlert) {
                        Button(LocalizedStringKey("cancel"), role: .cancel) { }
                        Button(LocalizedStringKey("delete"), role: .destructive) {
                            viewModel.deleteUser { success in
                                if success {
                                    dismiss()
                                }
                            }
                        }
                    } message: {
                        Text(LocalizedStringKey("delete_account_warning"))
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle(LocalizedStringKey("profile_information"))
        }
        .onChange(of: viewModel.isLoggedOut) { newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
