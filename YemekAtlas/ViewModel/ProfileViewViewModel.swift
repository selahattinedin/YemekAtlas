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
            errorMessage = "Kullanıcı oturumu bulunamadı"
            return
        }
        
        isLoading = true
        
        listenerRegistration = db.collection("users")
            .document(userId)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        print("Firestore hatası: \(error.localizedDescription)")
                        self.errorMessage = "Veri okuma hatası: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let document = documentSnapshot, document.exists,
                          let data = document.data() else {
                        print("Döküman bulunamadı veya boş")
                        self.errorMessage = "Kullanıcı bilgileri bulunamadı"
                        return
                    }
                    
                    // Firestore verilerini kontrol edelim
                    print("Firestore döküman verisi:", data)
                    
                    // Gerekli alanları kontrol et ve dönüştür
                    guard let name = data["name"] as? String,
                          let email = data["email"] as? String else {
                        print("Gerekli alanlar eksik veya yanlış formatta")
                        self.errorMessage = "Veri formatı uyumsuz"
                        return
                    }
                    
                    // joined ve lastLogin için timestamp kontrolü
                    let joined: TimeInterval
                    if let joinedTimestamp = data["joined"] as? Timestamp {
                        joined = Double(joinedTimestamp.seconds)
                    } else if let joinedInt = data["joined"] as? Int64 {
                        joined = Double(joinedInt)
                    } else if let joinedDouble = data["joined"] as? Double {
                        joined = joinedDouble
                    } else {
                        print("joined alanı uygun formatta değil")
                        self.errorMessage = "Veri formatı uyumsuz (joined)"
                        return
                    }

                    
                    // lastLogin için optional kontrol
                    var lastLogin: TimeInterval?
                    if let lastLoginTimestamp = data["lastLogin"] as? Timestamp {
                        lastLogin = Double(lastLoginTimestamp.seconds)
                    } else if let lastLoginInt = data["lastLogin"] as? Int64 {
                        lastLogin = Double(lastLoginInt)
                    } else if let lastLoginDouble = data["lastLogin"] as? Double {
                        lastLogin = lastLoginDouble
                    }
                    
                    // User nesnesini oluştur
                    let user = User(
                        id: document.documentID,
                        name: name,
                        email: email,
                        joined: joined,
                        lastLogin: lastLogin
                    )
                    
                    print("User nesnesi başarıyla oluşturuldu:", user)
                    self.user = user
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
    
    func deleteUser(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("Kullanıcı oturumu bulunamadı")
            self.errorMessage = "Kullanıcı oturumu bulunamadı"
            completion(false)
            return
        }

        let userId = user.uid
        let userRef = db.collection("users").document(userId)
        
        // Önce tüm alt koleksiyonları sil
        deleteAllSubcollections(userId: userId) { success in
            guard success else {
                self.errorMessage = "Alt koleksiyonlar silinemedi"
                completion(false)
                return
            }

            // Kullanıcı ana belgesini sil
            userRef.delete { error in
                if let error = error {
                    print("Firestore kullanıcı silme hatası: \(error.localizedDescription)")
                    self.errorMessage = "Kullanıcı verileri silinemedi: \(error.localizedDescription)"
                    completion(false)
                    return
                }

               
                user.delete { [weak self] error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Authentication silme hatası: \(error.localizedDescription)")
                        self.errorMessage = "Kullanıcı hesabı silinemedi: \(error.localizedDescription)"
                        
                        try? Auth.auth().signOut()
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.listenerRegistration?.remove()
                        self.isLoggedOut = true
                        self.user = nil
                        completion(true)
                    }
                }
            }
        }
    }

   
    func deleteAllSubcollections(userId: String, completion: @escaping (Bool) -> Void) {
        let userRef = db.collection("users").document(userId)

        userRef.collection("favorites").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Alt koleksiyon okunamadı: \(error.localizedDescription)")
                completion(false)
                return
            }

            let batch = self.db.batch()

            querySnapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }

            batch.commit { error in
                if let error = error {
                    print("Alt koleksiyonlar silinemedi: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Tüm alt koleksiyonlar silindi")
                    completion(true)
                }
            }
        }
    }

    
    deinit {
        listenerRegistration?.remove()
    }
}
