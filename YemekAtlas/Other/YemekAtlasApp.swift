import SwiftUI
import FirebaseCore

@main
struct YemekAtlasApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var localeManager = LocaleManager.shared
    @StateObject private var authViewModel = AuthViewViewModel.shared
    @State private var isShowingSplash = true
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isShowingSplash {
                    SplashScreen()
                } else {
                    MainView()
                        .environmentObject(appState)
                        .environmentObject(localeManager)
                        .environmentObject(authViewModel)
                        .environment(\.locale, localeManager.locale)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isShowingSplash = false
                    }
                }
            }
        }
    }
}
