import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedOut = false
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        setupUserListener()
    }
    
    func setupUserListener() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ Kullanıcı oturumu bulunamadı")
            errorMessage = "Kullanıcı oturumu bulunamadı"
            return
        }
        
        print("🔍 Kullanıcı verisi dinleyicisi başlatılıyor: \(userId)")
        isLoading = true
        
        listenerRegistration = db.collection("users")
            .document(userId)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        print("❌ Firestore hatası: \(error.localizedDescription)")
                        self.errorMessage = "Veri okuma hatası: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let document = documentSnapshot else {
                        print("❌ Döküman snapshot'ı alınamadı")
                        self.errorMessage = "Veri okunamadı"
                        return
                    }
                    
                    guard document.exists else {
                        print("❌ Kullanıcı dökümanı bulunamadı")
                        self.errorMessage = "Kullanıcı bilgileri bulunamadı"
                        return
                    }
                    
                    print("📄 Firestore döküman verisi: \(document.data() ?? [:])")
                    
                    do {
                        // DocumentSnapshot'ı direkt User modeline dönüştürmeyi dene
                        let user = try document.data(as: User.self)
                        self.user = user
                        print("✅ Kullanıcı verisi başarıyla yüklendi: \(user.name)")
                    } catch {
                        print("❌ Veri dönüştürme hatası: \(error.localizedDescription)")
                        
                        // Manuel dönüştürme dene
                        if let data = document.data() {
                            if let name = data["name"] as? String,
                               let email = data["email"] as? String,
                               let joined = data["joined"] as? TimeInterval {
                                
                                let lastLogin = data["lastLogin"] as? TimeInterval
                                
                                self.user = User(
                                    id: document.documentID,
                                    name: name,
                                    email: email,
                                    joined: joined,
                                    lastLogin: lastLogin
                                )
                                print("✅ Manuel dönüştürme başarılı: \(name)")
                            } else {
                                self.errorMessage = "Veri formatı uyumsuz"
                                print("❌ Gerekli alanlar bulunamadı veya yanlış formatta")
                            }
                        }
                    }
                }
            }
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        do {
            listenerRegistration?.remove()
            try Auth.auth().signOut()
            isLoggedOut = true
            user = nil
            completion(true)
        } catch {
            errorMessage = error.localizedDescription
            completion(false)
        }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}
