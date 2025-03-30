import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var authViewModel: AuthViewViewModel
    
    var body: some View {
        if !authViewModel.isSignedIn || appState.isFirstLaunch {
            FirstView(showFirstView: $appState.isFirstLaunch)
                .onAppear {
                    // Reset tab view selection when showing FirstView
                    appState.isAuthenticated = false
                }
        } else {
            MainTabView(selectedTab: .search)
        }
    }
}
