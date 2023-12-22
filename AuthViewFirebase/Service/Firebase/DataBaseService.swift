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
    
    private var currentUserId: String {
        return try! AuthenticationManager.shared.getAuthenticatedUser().uid
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
                self.usersRef.document(AuthService.shared.currentUser!.uid).collection("wishlist").document(present.id).setData(present.representation) { error in
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
        
        try await docRefUser(userID: currentUserId).updateData([
            "friends_id": FieldValue.arrayUnion([friendId])
        ])
        
        try await docRefFriend(friendID: friendId).updateData([
            "request_friend": FieldValue.arrayUnion([currentUserId])
        ])
    }
    
    
    // 2. Друг ответил на запрос (подписаться в ответ)
    
    func stepTwoForAddFriendPositive(friendId: String) async throws {
        
        try await docRefUser(userID: currentUserId).updateData([
            "request_friend": FieldValue.arrayRemove([friendId])
        ])
        
        try await docRefUser(userID: currentUserId).updateData([
            "friends_id": FieldValue.arrayUnion([friendId])
        ])
        
        try await docRefUser(userID: currentUserId).updateData([
            "my_subscribers": FieldValue.arrayUnion([friendId])
        ])
        
        try await docRefFriend(friendID: friendId).updateData([
            "my_subscribers": FieldValue.arrayUnion([currentUserId])
        ])
        
    }
    
    // 3. Друг ответил на запрос (отказал)
    
    func stepTwoForAddFriendNegative(friendId: String) async throws {
        
        try await docRefUser(userID: currentUserId).updateData([
            "request_friend": FieldValue.arrayRemove([friendId])
        ])
        
        try await docRefFriend(friendID: friendId).updateData([
            "friends_id": FieldValue.arrayRemove([currentUserId])
        ])
        
    }

    // 4. Отписаться от пользователя
    
    func deleteFriend(friendId: String) async throws {
        
        try await docRefUser(userID: currentUserId).updateData([
            "friends_id": FieldValue.arrayRemove([friendId])
        ])
        
        try await docRefFriend(friendID: friendId).updateData([
            "my_subscribers": FieldValue.arrayRemove([currentUserId])
        ])
        
    }
    
    
    
    
}

