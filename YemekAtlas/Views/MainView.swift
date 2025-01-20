import Foundation
import FirebaseAuth
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isSignIn, !viewModel.currentUserId.isEmpty {
            if viewModel.isEmailVerified {
                MainTabView(selectedTab: .search)
            } else {
                VerificationView()
            }
        } else {
            WelcomeView()
        }
    }
}
