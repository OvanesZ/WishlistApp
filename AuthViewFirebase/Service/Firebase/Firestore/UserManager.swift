//
//  UserManager.swift
//  Wishlist
//
//  Created by Ованес Захарян on 29.11.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable, Identifiable {
    
    var id: String
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    var dateBirth: Date?
//    var requestFriend: [String] = [""]
    let phoneNumber: String?
    var displayName: String?
    var userName: String?
    var userSerName: String?
    
    init(id: String, userId: String, isAnonimous: Bool?, email: String?, photoUrl: String?, dateCreated: Date?, isPremium: Bool?, dateBirth: Date?, phoneNumber: String?, displayName: String?, userName: String) {
        self.id = id
        self.userId = userId
        self.isAnonymous = isAnonimous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
        self.dateBirth = dateBirth
        self.phoneNumber = phoneNumber
        self.displayName = displayName
        self.userName = userName
    }
    
    init(auth: AuthDataResultModel) {
        self.id = auth.uid
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.isPremium = false
//        self.requestFriend = [""]
        self.phoneNumber = auth.phoneNumber
        self.displayName = auth.displayName
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
        case dateBirth = "date_birth"
//        case requestFriend = "request_friend"
        case phoneNumber = "phone_number"
        case displayName = "display_name"
        case userName = "user_name"
        case userSerName = "user_sername"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
        self.dateBirth = try container.decodeIfPresent(Date.self, forKey: .dateBirth)
//        self.requestFriend = try container.decodeIfPresent([String].self, forKey: .requestFriend) ?? [""]
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName)
        self.userSerName = try container.decodeIfPresent(String.self, forKey: .userSerName)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
        try container.encodeIfPresent(self.dateBirth, forKey: .dateBirth)
//        try container.encodeIfPresent(self.requestFriend, forKey: .requestFriend)
        try container.encodeIfPresent(self.phoneNumber, forKey: .phoneNumber)
        try container.encodeIfPresent(self.displayName, forKey: .displayName)
        try container.encodeIfPresent(self.userName, forKey: .userName)
        try container.encodeIfPresent(self.userSerName, forKey: .userSerName)

    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true)
    }
    
    func createNewPersonalDataUser(user: PersonalDataDBUser) async throws {
        try userCollection.document(user.userId).collection("personalData").document(user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func getUserPersonalData(userId: String) async throws -> PersonalDataDBUser {
        try await userCollection.document(userId).collection("personalData").document(userId).getDocument(as: PersonalDataDBUser.self)
    }
    
//    func updateDisplayName(userId: String, displayName: String) async throws {
//        let data: [String:Any] = [
//            DBUser.CodingKeys.displayName.rawValue : displayName
//        ]
//        try await userDocument(userId: userId).updateData(data)
//    }
    
//    func updateDateBirth(userId: String, date: Date) async throws {
//        let data: [String:Any] = [
//            DBUser.CodingKeys.dateBirth.rawValue : date
//        ]
//        try await userDocument(userId: userId).updateData(data)
//    }
    
    func updateDateBirth(userId: String, date: Date) {
        let data: [String:Any] = [
            DBUser.CodingKeys.dateBirth.rawValue : date
        ]
        userDocument(userId: userId).setData(data, merge: true)
    }
    
//    func updateUrlImage(userId: String, url: String) async throws {
//        let data: [String:Any] = [
//            PersonalDataDBUser.CodingKeys.photoUrl.rawValue : url
//        ]
//        try await userCollection.document(userId).collection("personalData").document(userId).updateData(data)
//    }
    
    func updateUserName(userId: String, userName: String, userSerName: String) {
        let data: [String:Any] = [
            DBUser.CodingKeys.userName.rawValue : userName,
            DBUser.CodingKeys.userSerName.rawValue : userSerName
        ]
        userDocument(userId: userId).setData(data, merge: true)
    }
 
    
    
}



struct PersonalDataDBUser: Codable {
    let userId: String
    var friendsId: [String] = [""]
    var mySubscribers: [String] = [""]
    var requestFriend: [String] = [""]
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.friendsId = [""]
        self.mySubscribers = [""]
        self.requestFriend = [""]
    }
    
    init(userId: String, friendsId: [String], mySubscribers: [String], requestFriend: [String]) {
        self.userId = userId
        self.friendsId = friendsId
        self.mySubscribers = mySubscribers
        self.requestFriend = requestFriend
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case friendsId = "friends_id"
        case mySubscribers = "my_subscribers"
        case requestFriend = "request_friend"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.friendsId = try container.decodeIfPresent([String].self, forKey: .friendsId) ?? [""]
        self.mySubscribers = try container.decodeIfPresent([String].self, forKey: .mySubscribers) ?? [""]
        self.requestFriend = try container.decodeIfPresent([String].self, forKey: .requestFriend) ?? [""]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.friendsId, forKey: .friendsId)
        try container.encodeIfPresent(self.mySubscribers, forKey: .mySubscribers)
        try container.encodeIfPresent(self.requestFriend, forKey: .requestFriend)
    }
}
