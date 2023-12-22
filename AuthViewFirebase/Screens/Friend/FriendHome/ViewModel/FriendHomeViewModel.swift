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
    
    let friend: DBUser
    @Published var wishlist: [PresentModel] = []
    @Published var isFriendForRequestArr = false
    @Published var isFriendForFriendstArr = false
    @Published var uiImage = UIImage(named: "person")
    
    init(friend: DBUser) {
        self.friend = friend
        fetchWishlistFriend()
        isFriendOrNo()
    }
    
    
    
    
    
    // MARK: -- (Добавление в друзья) Добавляю id друга в массив friendsID ///// Подписаться
   
//    func loadNewFriendInCollection (_ friend: DBUser) {
//        if let user = AuthService.shared.currentUser {
//            let docRefFriend = Firestore.firestore().collection("users").document(friend.userId)
//            let docRefUser = Firestore.firestore().collection("users").document(user.uid)
//            
//            docRefFriend.updateData([
//                "requestToFriend": FieldValue.arrayUnion([AuthService.shared.currentUser!.uid])
//            ]) { err in
//                if let err = err {
//                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
//                } else {
//                    print("мой id добавлен в массив requestToFriend друга")
//                }
//            }
//            
//            docRefUser.updateData([
//                "friendsID": FieldValue.arrayUnion([friend.userId])
//            ]) { err in
//                if let err = err {
//                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
//                } else {
//                    print("мой id добавлен в массив requestToFriend друга")
//                }
//            }
//        } else {
//            return
//        }
//    }
    
    // MARK: - Процедура подписки на пользователя
    
    //// ВАЖНО!!!! Перед этим у пользователя через google обязательно нужно создать подколлекцию personalData
    
    // 1. Пользователь нажал на кнопку подписаться у найденного друга
    
    func stepOneForAddFriend(friendId: String) async throws {
        try await DatabaseService.shared.stepOneUserPressedAddFriendButton(friendId: friendId)
    }
    
    // 2. Друг ответил на запрос (подписаться в ответ)
    
    func stepTwoAnswerToRequestPositive(friendId: String) async throws {
        try await DatabaseService.shared.stepTwoForAddFriendPositive(friendId: friendId)
    }
    
    // 3. Друг ответил на запрос (отказал)
    
    func stepTwoAnswerToRequestNegative(friendId: String) async throws {
        try await DatabaseService.shared.stepTwoForAddFriendNegative(friendId: friendId)
    }
    
    
    
    
    
    
    // MARK: -- Прослушиватель коллекции wishlist друга
    
    func fetchWishlistFriend() {
        let docRef = Firestore.firestore().collection("users").document(friend.userId).collection("wishlist")
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

                guard let idRequest = data["request_friend"] as? [String] else { return }
                guard let idFriends = data["friends_id"] as? [String] else { return }
                
                for id in idRequest {
                    if self.friend.userId == id {
                        self.isFriendForRequestArr = true
                    }
                }
                
                for id in idFriends {
                    if self.friend.userId == id {
                        self.isFriendForFriendstArr = true
                    }
                }
            }
        } else {
            return
        }
    }
    
    
//    func answerToRequestAllow() {
//        if let user = AuthService.shared.currentUser {
//            let docRefUser = Firestore.firestore().collection("users").document(user.uid)
//            
//            docRefUser.updateData([
//                "friendsID": FieldValue.arrayUnion([friend.userId]),
//                "requestToFriend": FieldValue.arrayRemove([friend.userId])
//            ]) { err in
//                if let err = err {
//                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
//                } else {
//                    print("мой id добавлен в массив requestToFriend друга")
//                }
//            }
//        } else {
//            return
//        }
//    }
//    
//    
//    func answerToRequestReject() {
//        if let user = AuthService.shared.currentUser {
//            let docRefUser = Firestore.firestore().collection("users").document(user.uid)
//            
//            docRefUser.updateData([
//                "requestToFriend": FieldValue.arrayRemove([friend.userId])
//            ]) { err in
//                if let err = err {
//                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
//                } else {
//                    print("мой id добавлен в массив requestToFriend друга")
//                }
//            }
//            
//            let docRefFriend = Firestore.firestore().collection("users").document(friend.userId)
//            
//            docRefFriend.updateData([
//                "friendsID": FieldValue.arrayRemove([AuthService.shared.currentUser!.uid])
//            ]) { err in
//                if let err = err {
//                    print("Возникла ошибка при добавлении id пользователя в коллекцию Friends: \(err)")
//                } else {
//                    print("мой id добавлен в массив requestToFriend друга")
//                }
//            }
//        } else {
//            return
//        }
//    }
    
    func getImage() {
        StorageService.shared.downloadUserImage(id: friend.userId) { result in
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
