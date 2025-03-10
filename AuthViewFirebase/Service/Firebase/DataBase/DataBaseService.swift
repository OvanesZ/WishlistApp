//
//  DataBaseService.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class DatabaseService {
    
    static let shared = DatabaseService()
    private let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var presentRef: CollectionReference {
        return db.collection("wishlist")
    }
    
    
    private var currentId: String {
        return Auth.auth().currentUser?.uid ?? "not auth user"
    }
    
    private func docRefFriend(friendID: String) -> DocumentReference {
        Firestore.firestore().collection("users").document(friendID).collection("personalData").document(friendID)
    }
    
    private func docRefUser(userID: String) -> DocumentReference {
        Firestore.firestore().collection("users").document(userID).collection("personalData").document(userID)
    }
    
    private init() { }
    
    
    func setProfile(user: UserModel, image: Data, completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        StorageService.shared.upload(id: user.id, image: image) { result in
            switch result {
            case .success(let sizeInfo):
                print(sizeInfo)
                self.usersRef.document(user.id).setData(user.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getProfile(completion: @escaping (Result<UserModel, Error>) -> Void) {
        
        if let user = AuthService.shared.currentUser {
            usersRef.document(user.uid).getDocument { docSnapshot, error in
                
                guard let snap = docSnapshot else { return }
                
                guard let data = snap.data() else { return }
                
                guard let id = data["id"] as? String else { return }
                guard let email = data["email"] as? String else { return }
                guard let displayName = data["displayName"] as? String else { return }
                guard let phoneNumber = data["phoneNumber"] as? Int? else { return }
                guard let address = data["address"] as? String else { return }
                guard let userImageURLText = data["userImageURLText"] as? String else { return }
                guard let friendsID = data["friendsID"] as? [String] else { return }
                guard let dateOfBirth = data["dateOfBirth"] as? Timestamp else { return }
                guard let requestToFriend = data["requestToFriend"] as? [String] else { return }
                
                
                let user = UserModel(id: id, email: email, displayName: displayName, phoneNumber: phoneNumber, address: address, userImageURLText: userImageURLText, friendsID: friendsID, dateOfBirth: dateOfBirth.dateValue(), requestToFriend: requestToFriend)
                
                completion(.success(user))
            }
        }
        
        
    }
    
    func setPresent(present: PresentModel, image: Data, completion: @escaping (Result <PresentModel, Error>) -> ()) {
        StorageService.shared.uploadPresentImage(id: present.id, image: image) { result in
            switch result {
            case .success(let sizeInfo):
                print(sizeInfo)
                self.usersRef.document(AuthService.shared.currentUser!.uid).collection("wishlist").document(present.id).setData(present.representation, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(present))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func setList(list: ListModel, image: Data, completion: @escaping (Result <ListModel, Error>) -> ()) {
        StorageService.shared.uploadListImage(id: list.id, image: image) { result in
            switch result {
            case .success(let sizeInfo):
                print(sizeInfo)
                self.usersRef.document(AuthService.shared.currentUser!.uid).collection("list").document(list.id).setData(list.representation, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(list))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setOtherWishlist(list: ListModel, present: PresentModel, image: Data, completion: @escaping (Result <PresentModel, Error>) -> ()) {
        StorageService.shared.uploadPresentImage(id: present.id, image: image) { result in
            switch result {
            case .success(let sizeInfo):
                print(sizeInfo)
                self.usersRef.document(AuthService.shared.currentUser!.uid).collection("list").document(list.id).collection("otherWishlist").document(present.id).setData(present.representation, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(present))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
    // MARK: - Процедура подписки на пользователя
    
    
    // 1. Пользователь нажал на кнопку подписаться у найденного друга
    
    func stepOneUserPressedAddFriendButton(friendId: String) async throws {
        var friendArrFriensID: [String] = []
        
        let document = try await docRefFriend(friendID: friendId).getDocument()
        guard let data = document.data() else { return }
        
        guard let id = data["friends_id"] as? [String] else { return }
        friendArrFriensID = id
       
        // Повторная подписка. Если ранее был подписан на друга, отписался, а друг не отписался, и при повторном нажатии на кнопку "Подписаться" выполняется этот алгоритм.
        
        for id in friendArrFriensID {
            if currentId == id {
                try await docRefUser(userID: currentId).updateData([
                    "friends_id": FieldValue.arrayUnion([friendId])
                ])
                
                try await docRefFriend(friendID: friendId).updateData([
                    "my_subscribers": FieldValue.arrayUnion([currentId])
                ])
                print("Повторная подписка на пользователя")
                return
            }
        }
        
        // Первичная подписка
        for id in friendArrFriensID {
            if currentId != id {
                try await docRefUser(userID: currentId).updateData([
                    "friends_id": FieldValue.arrayUnion([friendId])
                ])
                
                try await docRefFriend(friendID: friendId).updateData([
                    "request_friend": FieldValue.arrayUnion([currentId])
                ])
                print("Первичная подписка на пользователя")
            }
        }
        
    }
    
    // 2. Друг ответил на запрос (подписаться в ответ)
    
    func stepTwoForAddFriendPositive(friendId: String) async throws {
        
        try await docRefUser(userID: currentId).updateData([
            "request_friend": FieldValue.arrayRemove([friendId])
        ])
        
        try await docRefUser(userID: currentId).updateData([
            "friends_id": FieldValue.arrayUnion([friendId])
        ])
        
        try await docRefUser(userID: currentId).updateData([
            "my_subscribers": FieldValue.arrayUnion([friendId])
        ])
        
        try await docRefFriend(friendID: friendId).updateData([
            "my_subscribers": FieldValue.arrayUnion([currentId])
        ])
        
    }
    
    // 3. Друг ответил на запрос (отказал)
    
    func stepTwoForAddFriendNegative(friendId: String) async throws {
        
        try await docRefUser(userID: currentId).updateData([
            "request_friend": FieldValue.arrayRemove([friendId])
        ])
        
        try await docRefFriend(friendID: friendId).updateData([
            "friends_id": FieldValue.arrayRemove([currentId])
        ])
        
    }

    // 4. Отписаться от пользователя
    
    func deleteFriend(friendId: String) async throws {
        
        try await docRefUser(userID: currentId).updateData([
            "friends_id": FieldValue.arrayRemove([friendId])
        ])
        
        try await docRefFriend(friendID: friendId).updateData([
            "my_subscribers": FieldValue.arrayRemove([currentId])
        ])
        
    }
    
    
    // MARK: - Процесс отображения друзей во вкладке "Подписки" и "Подписчики"
    
    func getMyDocument() async throws -> DocumentSnapshot {
        try await Firestore.firestore().collection("users").document(currentId).collection("personalData").document(currentId).getDocument()
    }
    
    func getFriends(myFriendsID: [String]) async throws -> QuerySnapshot {
        try await Firestore.firestore().collection("users").whereField("user_id", in: myFriendsID).getDocuments()
    }
    
    // MARK: - Процесс получения всех пользователей
    
    func getAllUsers() async throws -> QuerySnapshot {
        try await Firestore.firestore().collection("users").getDocuments()
    }
    
    // MARK: - Прослушиватель всех пользователей
    
    func fetchUsers() -> QuerySnapshot? {
        Firestore.firestore().collection("users").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
        } as? QuerySnapshot
    }
    
//    func getWishlistByFriend(friendId: String) async throws -> QuerySnapshot {
//        try await Firestore.firestore().collection("users").document(friendId).collection("wishlist").getDocuments()
//    }

    
//    func setFriendPresentList(friendId: String, presentId: String) async throws {
//        
//        let data: [String:Any] = [
//            "present_id": presentId,
//            "friend_id": friendId
//        ]
//        
//        try await Firestore.firestore().collection("users").document(currentId).collection("presentsForFriend").document(presentId).setData(data)
//    }
    
    
    
    
    
    
    // MARK: - ReservedPresentsCardViewModel start func
    
    func setFriendPresentList(present: PresentModel) async throws {
        try Firestore.firestore().collection("users").document(currentId).collection("presentsForFriend").document(present.id).setData(from: present)
    }
    
    // MARK: - При отмене резерва подарка удаляю его из коллекции presentsForFriend
    
    func deletePresentFriendPresentList(present: PresentModel) async throws {
        try await Firestore.firestore().collection("users").document(currentId).collection("presentsForFriend").document(present.id).delete()
    }
    
    func getPresentsFromPresentsForFriend() async throws -> QuerySnapshot {
        try await Firestore.firestore().collection("users").document(currentId).collection("presentsForFriend").getDocuments()
    }
    
    func getPresentsForSell(ownerId: String, presentId: String) async throws -> PresentModel {
        try await Firestore.firestore().collection("users").document(ownerId).collection("wishlist").document(presentId).getDocument(as: PresentModel.self)
    }
    
    // Использую для загрузки друга в ячейку с подарком ReservedView
    func getFriendForCell(friendId: String) async throws -> DBUser {
        try await Firestore.firestore().collection("users").document(friendId).getDocument(as: DBUser.self)
    }
    
    // MARK: - end func for ReservedPresentsCardViewModel
    
    
    //MARK: -- Отмена резерва подарка без информации о друге
    func unReservingPresentForUserID(_ present: PresentModel, _ friendID: String) {
      
        let docRef = Firestore.firestore().collection("users").document(friendID).collection("wishlist").document(present.id)
        
        docRef.updateData([
            "isReserved": false,
            "whoReserved": ""
        ]) { error in
            if let error = error {
                print("Ошибка при обновлении документа \(error)")
            } else {
                print("Документ обновлен успешно")
            }
        }
    }
    
    
    
    
    
    
    
}

