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
    @Published var isLoading = false
    @Published var uiImage: UIImage? = nil
    @Published var isLoadImage = false
    
    private var myRequestID: [String] = [" "]
    private var mySubscribersID: [String] = [" "]
    
    //let manager = CacheManager.instanse
 
    init() {
        Task {
            try? await getMyRequestID()
            try? await getRequest()
        }
    }

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
        self.isLoading = true
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["friends_id"] as? [String] else { return }
        self.myFriendsID = id
    }
    
    
    func getSubscriptions() async throws {
        
        try await self.myFriends = DatabaseService.shared.getFriends(myFriendsID: myFriendsID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
        self.isLoading = false
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
    
//    func getImage(friendID: String) {
//        self.isLoadImage = true
//        
//        StorageService.shared.downloadUserImage(id: friendID) { result in
//            switch result {
//            case .success(let data):
//                self.isLoadImage = false
//                if let img = UIImage(data: data) {
//                    self.uiImage = img
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    /*
    // MARK: - Работа с кэш
    
    func saveToCache(userIdForNameImage: String) {
        guard let image = uiImage else { return }
        manager.add(image: image, name: userIdForNameImage)
    }
    
    func removeFromCache(userIdForNameImage: String) {
        manager.remove(name: userIdForNameImage)
    }
    
    func getFromCache(userIdForNameImage: String) {
        cahedImage = manager.get(name: userIdForNameImage)
    }
     */
    
    func getUrlImageFriendAsync(id: String) async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: id)
    }
   
    
    
}



