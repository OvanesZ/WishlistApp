//
//  FriendHomeViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


class FriendHomeViewModel: ObservableObject {
    
    let friend: UserModel
    @Published var wishlist: [PresentModel] = []
    @Published var isFriendForRequestArr = false
    @Published var isFriendForFriendstArr = false
    @Published var uiImage = UIImage(named: "person")
    
    init(friend: UserModel) {
        self.friend = friend
        fetchWishlistFriend()
        isFriendOrNo()
    }
    
    
//    // MARK: -- (Добавление в друзья) Добавляю id друга в массив friendsID ///// Подписаться
//
//    func loadNewFriendInCollection (_ friend: UserModel) {
//        let docRef = Firestore.firestore().collection("Users").document(AuthService.shared.currentUser!.uid)
//
//        docRef.updateData([
//            "friendsID": FieldValue.arrayUnion([friend.id])
//        ]) { err in
//            if let err = err {
//                print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
//            } else {
//                print("id пользователя добавлен в коллекцию Friends")
//            }
//        }
//    }
    
    // MARK: -- (Добавление в друзья) Добавляю id друга в массив friendsID ///// Подписаться
   
    func loadNewFriendInCollection (_ friend: UserModel) {
        if let user = AuthService.shared.currentUser {
            let docRefFriend = Firestore.firestore().collection("Users").document(friend.id)
            let docRefUser = Firestore.firestore().collection("Users").document(user.uid)
            
            docRefFriend.updateData([
                "requestToFriend": FieldValue.arrayUnion([AuthService.shared.currentUser!.uid])
            ]) { err in
                if let err = err {
                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
                } else {
                    print("мой id добавлен в массив requestToFriend друга")
                }
            }
            
            docRefUser.updateData([
                "friendsID": FieldValue.arrayUnion([friend.id])
            ]) { err in
                if let err = err {
                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
                } else {
                    print("мой id добавлен в массив requestToFriend друга")
                }
            }
        } else {
            return
        }
    }
    
    // MARK: -- Прослушиватель коллекции wishlist друга
    
    func fetchWishlistFriend() {
        let docRef = Firestore.firestore().collection("users").document(friend.id).collection("wishlist")
        docRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.wishlist = snapshot?.documents.compactMap {
                try? $0.data(as: PresentModel.self)
            } ?? []
        }
    }
    
    // MARK: -- Прослушиватель, если id друга есть в массиве myFriendsID то statusFriend = true (тогда скрываю кнопку "Подписаться")
    
    func isFriendOrNo() {
        
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

                guard let idRequest = data["requestToFriend"] as? [String] else { return }
                guard let idFriends = data["friendsID"] as? [String] else { return }
                
                for id in idRequest {
                    if self.friend.id == id {
                        self.isFriendForRequestArr.toggle()
                    }
                }
                
                for id in idFriends {
                    if self.friend.id == id {
                        self.isFriendForFriendstArr.toggle()
                    }
                }
            }
        } else {
            return
        }
    }
    
    
    func answerToRequestAllow() {
        if let user = AuthService.shared.currentUser {
            let docRefUser = Firestore.firestore().collection("Users").document(user.uid)
            
            docRefUser.updateData([
                "friendsID": FieldValue.arrayUnion([friend.id]),
                "requestToFriend": FieldValue.arrayRemove([friend.id])
            ]) { err in
                if let err = err {
                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
                } else {
                    print("мой id добавлен в массив requestToFriend друга")
                }
            }
        } else {
            return
        }
    }
    
    
    func answerToRequestReject() {
        if let user = AuthService.shared.currentUser {
            let docRefUser = Firestore.firestore().collection("Users").document(user.uid)
            
            docRefUser.updateData([
                "requestToFriend": FieldValue.arrayRemove([friend.id])
            ]) { err in
                if let err = err {
                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
                } else {
                    print("мой id добавлен в массив requestToFriend друга")
                }
            }
            
            let docRefFriend = Firestore.firestore().collection("Users").document(friend.id)
            
            docRefFriend.updateData([
                "friendsID": FieldValue.arrayRemove([AuthService.shared.currentUser!.uid])
            ]) { err in
                if let err = err {
                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
                } else {
                    print("мой id добавлен в массив requestToFriend друга")
                }
            }
        } else {
            return
        }
    }
    
    func getImage() {
        StorageService.shared.downloadUserImage(id: friend.id) { result in
            switch result {
            case .success(let data):
                if let img = UIImage(data: data) {
                    self.uiImage = img
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
