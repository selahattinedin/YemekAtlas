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
            errorMessage = "User session not found"
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
                        print("Firestore error: \(error.localizedDescription)")
                        self.errorMessage = "Data reading error: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let document = documentSnapshot, document.exists,
                          let data = document.data() else {
                        print("Document not found or empty")
                        self.errorMessage = "User information not found"
                        return
                    }
                    
                    // Let's check Firestore data
                    print("Firestore document data:", data)
                    
                    // Check and convert the necessary fields
                    guard let name = data["name"] as? String,
                          let email = data["email"] as? String else {
                        print("Required fields are missing or in wrong format")
                        self.errorMessage = "Incompatible data format"
                        return
                    }
                    
                    // Check timestamp for joined and lastLogin
                    let joined: TimeInterval
                    if let joinedTimestamp = data["joined"] as? Timestamp {
                        joined = Double(joinedTimestamp.seconds)
                    } else if let joinedInt = data["joined"] as? Int64 {
                        joined = Double(joinedInt)
                    } else if let joinedDouble = data["joined"] as? Double {
                        joined = joinedDouble
                    } else {
                        print("Joined field is not in a proper format")
                        self.errorMessage = "Incompatible data format (joined)"
                        return
                    }

                    
                    // Optional check for lastLogin
                    var lastLogin: TimeInterval?
                    if let lastLoginTimestamp = data["lastLogin"] as? Timestamp {
                        lastLogin = Double(lastLoginTimestamp.seconds)
                    } else if let lastLoginInt = data["lastLogin"] as? Int64 {
                        lastLogin = Double(lastLoginInt)
                    } else if let lastLoginDouble = data["lastLogin"] as? Double {
                        lastLogin = lastLoginDouble
                    }
                    
                    // Create the User object
                    let user = User(
                        id: document.documentID,
                        name: name,
                        email: email,
                        joined: joined,
                        lastLogin: lastLogin
                    )
                    
                    print("User object created successfully:", user)
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
            print("User session not found")
            self.errorMessage = "User session not found"
            completion(false)
            return
        }

        let userId = user.uid
        let userRef = db.collection("users").document(userId)
        
        // First, delete all subcollections
        deleteAllSubcollections(userId: userId) { success in
            guard success else {
                self.errorMessage = "Subcollections could not be deleted"
                completion(false)
                return
            }

            // Delete the main user document
            userRef.delete { error in
                if let error = error {
                    print("Firestore delete user error: \(error.localizedDescription)")
                    self.errorMessage = "User data could not be deleted: \(error.localizedDescription)"
                    completion(false)
                    return
                }

               
                user.delete { [weak self] error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Authentication delete error: \(error.localizedDescription)")
                        self.errorMessage = "User account could not be deleted: \(error.localizedDescription)"
                        
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
                print("Subcollections could not be read: \(error.localizedDescription)")
                completion(false)
                return
            }

            let batch = self.db.batch()

            querySnapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }

            batch.commit { error in
                if let error = error {
                    print("Subcollections could not be deleted: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("All subcollections deleted")
                    completion(true)
                }
            }
        }
    }

    
    deinit {
        listenerRegistration?.remove()
    }
}
