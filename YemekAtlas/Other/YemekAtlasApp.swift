import SwiftUI
import FirebaseCore
import FirebaseStorage

@main
struct YemekAtlasApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var localeManager = LocaleManager.shared
    @StateObject private var authViewModel = AuthViewViewModel.shared
    @State private var isShowingSplash = true
    
    init() {
        FirebaseApp.configure()
        
        // Storage ayarlarını yapılandır
        let storage = Storage.storage()
        print("Firebase Storage URL: \(storage.reference().description)")
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
