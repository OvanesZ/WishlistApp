//
//  PresentModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct PresentModel: Codable, Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var name: String
    var urlText: String
    var presentFromUserID: String
    var isReserved = false
    var presentDescription = ""
    var ownerId: String
    var whoReserved: String
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["urlText"] = self.urlText
        repres["presentFromUserID"] = self.presentFromUserID
        repres["isReserved"] = self.isReserved
        repres["presentDescription"] = self.presentDescription
        repres["ownerId"] = self.ownerId
        repres["whoReserved"] = self.whoReserved
        
        return repres
    }
    
 
}


struct ListModel: Codable, Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var name: String
    var date: Date
    
    var representation: [String: Any] {
        var repres = [String: Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        repres["date"] = Timestamp(date: date)
        
        return repres
    }
    
 
}




