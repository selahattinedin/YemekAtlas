import SwiftUI
import FirebaseCore

@main
struct YemekAtlasApp: App {
    @State var showFirstView = true
    @StateObject private var localeManager = LocaleManager.shared

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if showFirstView {
                FirstView(showFirstView: $showFirstView)
            } else {
                MainTabView(selectedTab: .search)
                    .environment(\.locale, localeManager.locale)
            }
        }
    }
}
