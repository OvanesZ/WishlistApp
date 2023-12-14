//
//  PresentModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//struct PresentModel: Codable, Identifiable {
//
//    @DocumentID var id: String?
//    var name: String? = ""
//    var havePhoto: Bool = false
//    var urlText = ""
//
//    var presentFromUser: UserModel = UserModel(id: "", email: "", displayName: "", phoneNumber: 0, address: "", dateOfBirth: Date())
//
//    var isReserved = false
//
//    var presentImageURLText = ""
//    var presentImage: URL? { URL(string: "\(presentImageURLText)")}
//    var presentDescription = ""
//
//
//}

struct PresentModel: Codable, Identifiable {
    
    var id: String = UUID().uuidString
    var name: String
    var urlText: String
    var presentFromUserID: String
    var isReserved = false
    var presentDescription = ""
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["urlText"] = self.urlText
        repres["presentFromUserID"] = self.presentFromUserID
        repres["isReserved"] = self.isReserved
        repres["presentDescription"] = self.presentDescription
        
        return repres
    }
    
 
}
