//
//  FriendsViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import Combine
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage



final class FriendsViewModel: ObservableObject {
    
    @Published var allUsers: [DBUser] = []
    @Published var myFriends: [DBUser] = []
    @Published var mySubscribers: [DBUser] = []
    @Published var myRequest: [DBUser] = []
    @Published var allFriendsUser: [DBUser] = []
    
    @Published var myFriendsID: [String] = [" "]
    var myRequestID: [String] = [" "]
    var mySubscribersID: [String] = [" "]
    var testId = ["PLit2ZRFRqaVKz5qqRahwLPFHAB2"]
    
    // MARK: -- Прослушиватель всех пользователей
    
 
    
    func fetchUsers() {
        Firestore.firestore().collection("users").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.allUsers = snapshot?.documents.compactMap {
                try? $0.data(as: DBUser.self)
            } ?? []
        }
    }
    
    // MARK: -- Удаляю друга из коллекции "Friends"
    
//    func removingFriendFromFriends(_ email: String) {
//        let docRef = Firestore.firestore().collection("User").document(currentUser?.email ?? "").collection("Friends").document(email)
//
//        docRef.delete() { error in
//            if let error = error {
//                print(error)
//            } else {
//                print("Пользователь удален успешно")
//            }
//        }
//    }
    

    func getMyFriendsID() {
        
        if let userId = try? AuthenticationManager.shared.getAuthenticatedUser().uid {
            let docRef = Firestore.firestore().collection("users").document(userId).collection("personalData").document(userId)
            
            docRef.addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Ошибка при получении id друзей \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Документ пустой")
                    return
                }
                
                guard let id = data["friends_id"] as? [String] else { return }
                self.myFriendsID = id
            }
            
        } else {
            return
        }
        
        
    }
    
    // MARK: -- Прослушиваю авторизованного пользователя и кладу id друзей в массив myFriendsID и затем по фильтру in: myFriendsID прослушиваю изменения у друзей
    
    
    func getFriendsAsync() async throws {
       
        do {
            let querySnapshot = try await Firestore.firestore().collection("users").whereField("user_id", in: myFriendsID).getDocuments()
            
            self.myFriends = querySnapshot.documents.compactMap {
                try? $0.data(as: DBUser.self)
            }
            
        } catch {
            print("Error getting documents: \(error)")
        }
        
    }
    
    
    
    func getFriends() {
        
        Firestore.firestore().collection("users").whereField("user_id", in: myFriendsID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                self.myFriends = querySnapshot?.documents.compactMap {
                    try? $0.data(as: DBUser.self)
                } ?? []
            }
        }
        
    }
    
    // MARK: -- Прослушиваю

    func getRequest() {
        
        if let userId = try? AuthenticationManager.shared.getAuthenticatedUser().uid {
            let docRef = Firestore.firestore().collection("users").document(userId).collection("personalData").document(userId)
            
            docRef.addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Ошибка при получении id друзей \(error!)")
                    return
                }

                guard let data = document.data() else {
                    print("Документ пустой")
                    return
                }

                guard let id = data["request_friend"] as? [String] else { return }
                self.myRequestID = id
            }
            
            Firestore.firestore().collection("users").whereField("user_id", in: myRequestID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.myRequest = querySnapshot?.documents.compactMap {
                        try? $0.data(as: DBUser.self)
                    } ?? []
                }
            }
        } else {
            return
        }
    }
    
    func getMySubscribers() {
        if let userId = try? AuthenticationManager.shared.getAuthenticatedUser().uid {
            
            Firestore.firestore().collection("users").document(userId).collection("personalData").document(userId).addSnapshotListener { snapshot, error in
                
                guard let document = snapshot else {
                    print("Ошибка при получении id друзей \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Документ пустой")
                    return
                }
                
                guard let id = data["my_subscribers"] as? [String] else { return }
                self.mySubscribersID = id
            }
            
            Firestore.firestore().collection("users").whereField("user_id", in: mySubscribersID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.mySubscribers = querySnapshot?.documents.compactMap {
                        try? $0.data(as: DBUser.self)
                    } ?? []
                }
            }
        } else {
            return
        }
    }
    
    
}



