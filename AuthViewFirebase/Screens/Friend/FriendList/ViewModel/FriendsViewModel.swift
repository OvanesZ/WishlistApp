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
    
    @Published var allUsers: [UserModel] = []
    @Published var myFriends: [UserModel] = []
    @Published var myRequest: [UserModel] = []
    @Published var allFriendsUser: [UserModel] = []
    
    var myFriendsID: [String] = [" "]
    var myRequestID: [String] = [" "]
    
    // MARK: -- Прослушиватель всех пользователей
    
 
    func fetchUsers() {
        Firestore.firestore().collection("Users").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            self.allUsers = snapshot?.documents.compactMap {
                try? $0.data(as: UserModel.self)
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
    
    
    
    // MARK: -- Прослушиваю авторизованного пользователя и кладу id друзей в массив myFriendsID и затем по фильтру in: myFriendsID прослушиваю изменения у друзей

    func getFriends() {
        
        if let user = AuthService.shared.currentUser {
            let docRef = Firestore.firestore().collection("Users").document(user.uid)
            
            docRef.addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Ошибка при получении id друзей \(error!)")
                    return
                }

                guard let data = document.data() else {
                    print("Документ пустой")
                    return
                }

                guard let id = data["friendsID"] as? [String] else { return }
                self.myFriendsID = id
            }
            
            Firestore.firestore().collection("Users").whereField("id", in: myFriendsID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    self.myFriends = querySnapshot?.documents.compactMap {
                        try? $0.data(as: UserModel.self)
                    } ?? []
                }
            }
        } else {
            return
        }
    }
    
    // MARK: -- Прослушиваю

    func getRequest() {
        
        if let user = AuthService.shared.currentUser {
            let docRef = Firestore.firestore().collection("Users").document(user.uid)
            docRef.addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Ошибка при получении id друзей \(error!)")
                    return
                }

                guard let data = document.data() else {
                    print("Документ пустой")
                    return
                }

                guard let id = data["requestToFriend"] as? [String] else { return }
                self.myRequestID = id
            }
            
            Firestore.firestore().collection("Users").whereField("id", in: myRequestID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.myRequest = querySnapshot?.documents.compactMap {
                        try? $0.data(as: UserModel.self)
                    } ?? []
                }
            }
        } else {
            return
        }
    }
    
//    func setFollowing() {
//        let docRefUser = Firestore.firestore().collection("Users").document(AuthService.shared.currentUser!.uid).collection("Following").document(friend.id)
//        
//        let docData: [String: Any] = [
//            "id": friend.id,
//            "status": false
//        ]
//        
//        docRefUser.setData(docData) { error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Done")
//            }
//        }
//        
//        
//        let docRefFriend = Firestore.firestore().collection("Users").document(friend.id).collection("Followers").document(AuthService.shared.currentUser!.uid)
//        
//        let docDataFriend: [String: Any] = [
//            "id": AuthService.shared.currentUser!.uid,
//            "status": false
//        ]
//        
//        docRefFriend.setData(docDataFriend) { error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Done")
//            }
//        }
//        
//        
//        
//    }
//    
//    func changeStatus() {
//        let docRefUser = Firestore.firestore().collection("Users").document(AuthService.shared.currentUser!.uid).collection("Following").document(friend.id)
//        
//        docRefUser.updateData([
//            "status": true
//        ]) { error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Done")
//            }
//        }
//        
//        let docRefFriend = Firestore.firestore().collection("Users").document(friend.id).collection("Followers").document(AuthService.shared.currentUser!.uid)
//        
//        docRefFriend.updateData([
//            "status": true
//        ]) { error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Done")
//            }
//        }
//    }
//    
//    
//    func fetchFollowers() {
////        let docRef = Firestore.firestore().collection("Users").document(AuthService.shared.currentUser!.uid).collection("Followers")
//        
//        
//        
//        
//    }
    
    
    
}



