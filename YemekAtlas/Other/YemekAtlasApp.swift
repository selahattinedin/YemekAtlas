import SwiftUI
import FirebaseCore

@main
struct YemekAtlasApp: App {
    @State var showPreviewPage = true
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "en"
    
    init() {
        FirebaseApp.configure()
        // Kaydedilmiş dil varsa onu kullan
        if let languageCode = UserDefaults.standard.string(forKey: "selectedLanguage") {
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if showPreviewPage {
                FirstView()
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            showPreviewPage = false
                        }
                    }
            } else {
                MainView()
                    .environment(\.locale, Locale(identifier: selectedLanguage))
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
                        // Dil değiştiğinde yapılacak işlemler
                        // Örneğin: uygulamayı yeniden başlatmak için gerekli işlemler
                        reloadApp()
                    }
            }
        }
    }
    
    private func reloadApp() {
        // Uygulamayı programmatik olarak yeniden başlat
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.dismiss(animated: true)
        
        // Opsiyonel: Kısa bir gecikme sonrası ana ekranı tekrar göster
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            showPreviewPage = true
        }
    }
}
