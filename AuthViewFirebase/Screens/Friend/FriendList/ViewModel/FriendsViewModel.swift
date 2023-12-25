//
//  FriendsViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI


@MainActor
final class FriendsViewModel: ObservableObject {
    
    @Published var myFriends: [DBUser] = []
    @Published var allUsers: [DBUser] = []
    @Published var mySubscribers: [DBUser] = []
    @Published var myRequest: [DBUser] = []
    @Published var allFriendsUser: [DBUser] = []
    
    @Published var myFriendsID: [String] = [" "]
    var myRequestID: [String] = [" "]
    var mySubscribersID: [String] = [" "]
    

    // MARK: - НЕ УДАЛЯТЬ!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
//    func fetchUsers() {
//        
//        self.allUsers = DatabaseService.shared.fetchUsers()?.documents.compactMap {
//            try? $0.data(as: DBUser.self)
//        } ?? []
//        
//    }
    
    func getAllUsers() async throws {
        self.allUsers = try await DatabaseService.shared.getAllUsers().documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    
    // MARK: - Процесс отображения друзей во вкладке "Подписки" и "Подписчики"
    
    func getMyFriendsID() async throws {
        
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["friends_id"] as? [String] else { return }
        self.myFriendsID = id
    }
    
    
    func getSubscriptions() async throws {
        try await self.myFriends = DatabaseService.shared.getFriends(myFriendsID: myFriendsID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    func getMySubscribersID() async throws {
        
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["my_subscribers"] as? [String] else { return }
        self.mySubscribersID = id
    }
    
    func getSubscribers() async throws {
        try await self.mySubscribers = DatabaseService.shared.getFriends(myFriendsID: mySubscribersID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    
    
    func getMyRequestID() async throws {
        
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["request_friend"] as? [String] else { return }
        self.myRequestID = id
    }
    
    func getRequest() async throws {
        try await self.myRequest = DatabaseService.shared.getFriends(myFriendsID: myRequestID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    
}



