//
//  WishlistManager.swift
//  Wishlist
//
//  Created by Ованес Захарян on 30.11.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBPresent: Codable {
    var presentId: String = UUID().uuidString
    let name: String?
    let urlText: String?
    let presentFromUserId: String?
    var isReserved: Bool = false
    let presentDescription: String?
    
    init(presentId: String, name: String?, urlText: String?, presentFromUserId: String?, isReserved: Bool, presentDescription: String?) {
        self.presentId = UUID().uuidString
        self.name = name
        self.urlText = urlText
        self.presentFromUserId = presentFromUserId
        self.isReserved = isReserved
        self.presentDescription = presentDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case presentId = "present_id"
        case name = "name"
        case urlText = "url_text"
        case presentFromUserId = "present_from_user_id"
        case isReserved = "is_reserved"
        case presentDescription = "present_description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.presentId = try container.decode(String.self, forKey: .presentId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.urlText = try container.decodeIfPresent(String.self, forKey: .urlText)
        self.presentFromUserId = try container.decodeIfPresent(String.self, forKey: .presentFromUserId)
        self.isReserved = try container.decodeIfPresent(Bool.self, forKey: .isReserved) ?? false
        self.presentDescription = try container.decodeIfPresent(String.self, forKey: .presentDescription)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.presentId, forKey: .presentId)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.urlText, forKey: .urlText)
        try container.encodeIfPresent(self.presentFromUserId, forKey: .presentFromUserId)
        try container.encodeIfPresent(self.isReserved, forKey: .isReserved)
        try container.encodeIfPresent(self.presentDescription, forKey: .presentDescription)
    }
    
}



final class PresentManager {
    
    static let shared = PresentManager()
    private init() { }
    
    private let presentCollection = Firestore.firestore().collection("wishlist")
    
    private func presentDocument(presentId: String) -> DocumentReference {
        presentCollection.document(presentId)
    }
    
    
    func createNewPresent(userId: String, present: DBPresent) async throws {
//        try presentDocument(presentId: present.presentId).setData(from: present, merge: false)
        try Firestore.firestore().collection("users").document(userId).collection("wishlist").document(present.presentId).setData(from: present, merge: false)
    }
    
    func getPresent(presentId: String) async throws -> DBPresent {
        try await presentDocument(presentId: presentId).getDocument(as: DBPresent.self)
    }
    
//    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
//        let data: [String:Any] = [
//            DBUser.CodingKeys.isPremium.rawValue : isPremium
//        ]
//        try await userDocument(userId: userId).updateData(data)
//    }
    
    
}
