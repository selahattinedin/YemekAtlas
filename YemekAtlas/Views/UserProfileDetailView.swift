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
                        Section("Personal Information") {
                            HStack {
                                Text("Full Name")
                                Spacer()
                                Text(user.name)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("Email")
                                Spacer()
                                Text(user.email)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("Join Date")
                                Spacer()
                                Text(Date(timeIntervalSince1970: user.joined)
                                    .formatted(date: .abbreviated, time: .omitted))
                                    .foregroundColor(.gray)
                            }
                            
                            if let lastLogin = user.lastLogin {
                                HStack {
                                    Text("Last Login")
                                    Spacer()
                                    Text(Date(timeIntervalSince1970: lastLogin)
                                        .formatted(date: .abbreviated, time: .omitted))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section {
                            Button("Delete My Account") {
                                showingAlert = true
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("foodbackcolor"))
                            .cornerRadius(8)
                        }
                    }
                    .alert("You Are About to Delete Your Account", isPresented: $showingAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            viewModel.deleteUser { success in
                                if success {
                                    // Return to LoginView when user is deleted
                                    dismiss()
                                }
                            }
                        }
                    } message: {
                        Text("This action cannot be undone. Are you sure?")
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile Information")
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
