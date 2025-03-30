import SwiftUI
import FirebaseCore

@main
struct YemekAtlasApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var localeManager = LocaleManager.shared
    @StateObject private var authViewModel = AuthViewViewModel.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .environmentObject(localeManager)
                .environmentObject(authViewModel)
        }
    }
}
