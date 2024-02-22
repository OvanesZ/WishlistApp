//
//  ReservedPresentsCardViewModel.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.02.2024.
//

import SwiftUI

final class ReservedPresentsCardViewModel: ObservableObject {
    
    @Published var presents: [PresentModel] = []
    @Published var presentsForSell: [PresentModel] = []
//    @Published var image = UIImage(named: "person")!
    
    
    func getFriend(friendId: String) async throws -> DBUser {
        try await DatabaseService.shared.getFriendForCell(friendId: friendId)
    }
   
    func getPresentsFromPresentsForFriend() async throws {
        self.presents = try await DatabaseService.shared.getPresentsFromPresentsForFriend().documents.compactMap {
            try? $0.data(as: PresentModel.self)
        }
    }
    
    func getPresents() async throws {
        
        for present in presents {
            let present = try await DatabaseService.shared.getPresentsForSell(ownerId: present.ownerId, presentId: present.id)
            self.presentsForSell.append(present)
        }
    }
    
    func getUrlPresentImage(presentId: String) async throws -> URL {
        try await StorageService.shared.downloadURLPresentImageAsync(id: presentId)
    }
    
    func getUrlFriendImage(friendId: String) async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: friendId)
    }
    
    
}



