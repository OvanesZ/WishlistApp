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
    var testId = [" ", "PLit2ZRFRqaVKz5qqRahwLPFHAB2"]
    
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
    
    // MARK: - Процесс отображения друзей во вкладке "Подписки" и "Подписчики"
    
    func getMyFriendsID() async throws {
        
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else {
            print("Документ пустой")
            return
        }
        
        guard let id = data["friends_id"] as? [String] else { return }
        self.myFriendsID = id
    }
    
    
    func getSubscriptions() async throws {
        try await self.myFriends = DatabaseService.shared.getFriends(myFriendsID: myFriendsID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    func getMySubscribersID() async throws {
        
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else {
            print("Документ пустой")
            return
        }
        
        guard let id = data["my_subscribers"] as? [String] else { return }
        self.mySubscribersID = id
    }
    
    func getSubscribers() async throws {
        try await self.mySubscribers = DatabaseService.shared.getFriends(myFriendsID: mySubscribersID).documents.compactMap {
            try? $0.data(as: DBUser.self)
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



