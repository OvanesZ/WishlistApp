//
//  ReservedPresentsCardViewModel.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.02.2024.
//

import SwiftUI

final class ReservedPresentsCardViewModel: ObservableObject {
    
    @Published var friendsAndPresent: [String : String] = [:]
    @Published var presents: [PresentModel] = []
    @Published var friends: [DBUser] = []
    
    func getDict() async throws {
        self.friendsAndPresent = try await DatabaseService.shared.getFriendPresentList()
    }
    
    func test() async throws {
        self.presents = try await DatabaseService.shared.tes(dict: self.friendsAndPresent)
    }
    
    func setFriends() async throws {
        self.friends = try await DatabaseService.shared.setFriends(dict: self.friendsAndPresent)
    }
    
    
    func getFriend(friendId: String) async throws -> DBUser {
        try await DatabaseService.shared.getFriendForCell(friendId: friendId)
    }
    
}



