//
//  UserModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct UserModel: Codable, Identifiable {
    
    var id: String
    var email: String
    var displayName: String
    var phoneNumber: Int?
    var address: String
    var userImageURLText = ""
    var userImage: URL? { URL(string: "\(userImageURLText)")}
    var friendsID: [String] = [""]
    var dateOfBirth: Date
    var requestToFriend: [String] = [""]
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["email"] = self.email
        repres["displayName"] = self.displayName
        repres["phoneNumber"] = self.phoneNumber
        repres["address"] = self.address
        repres["userImageURLText"] = self.userImageURLText
        repres["friendsID"] = self.friendsID
        repres["dateOfBirth"] = Timestamp(date: dateOfBirth)
        repres["requestToFriend"] = self.requestToFriend
        
        return repres
    }
    
}
