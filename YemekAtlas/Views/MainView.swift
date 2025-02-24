import SwiftUI
import FirebaseAuth

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    @ObservedObject private var localeManager = LocaleManager.shared

    var body: some View {
        if viewModel.isSignIn, !viewModel.currentUserId.isEmpty {
            if viewModel.isEmailVerified {
                MainTabView(selectedTab: .search)
                    .environment(\.locale, localeManager.locale)
            } else {
                VerificationView()
                    .environment(\.locale, localeManager.locale)
            }
        } else {
            WelcomeView()
                .environment(\.locale, localeManager.locale)
        }
    }
}
