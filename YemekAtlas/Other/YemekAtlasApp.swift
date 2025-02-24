import SwiftUI
import FirebaseCore

@main
struct YemekAtlasApp: App {
    @State var showPreviewPage = true
    @StateObject private var localeManager = LocaleManager.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if showPreviewPage {
                FirstView()
                    .environment(\.locale, localeManager.locale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showPreviewPage = false
                        }
                    }
            } else {
                MainView()
                    .environment(\.locale, localeManager.locale)
            }
        }
    }
}
