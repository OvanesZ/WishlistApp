//
//  SettingsViewModel.swift
//  Wishlist
//
//  Created by Ованес Захарян on 07.12.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published private(set) var dbUser: DBUser? = nil
    @Published private(set) var dbUserPersonalData: PersonalDataDBUser? = nil
    @Published private(set) var friendDbUserPersonalData: PersonalDataDBUser? = nil
    @Published var image = UIImage(named: "person")!
    @Published var user: PersonalDataDBUser? = nil
    
    
    let manager = CacheManager.instanse
    
    // MARK: - functions
    
    
    
    func saveToCache(userIdForNameImage: String) {
        manager.add(image: image, name: userIdForNameImage)
    }
    
    func getUrlImageAsync() async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: dbUserPersonalData?.userId ?? "")
    }
    
    func getUrlImageFriendAsync(id: String) async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: id)
    }
    
    func getImageAsync() async throws {
        Task {
            let data = try await StorageService.shared.downloadUserImageAsync(id: dbUserPersonalData?.userId ?? "")
            if let img = UIImage(data: data) {
                self.image = img
            }
        }
    }
    
    func uploadImageAsync() {
        guard let imageData = image.jpegData(compressionQuality: 0.15) else { return }
        Task {
            try await StorageService.shared.uploadAsync(id: dbUserPersonalData?.userId ?? "", data: imageData)
        }
    }
    
    func updateDisplayName(userName: String) {
        guard let dbUser else { return }
        Task {
            try await UserManager.shared.updateDisplayName(userId: dbUser.userId, displayName: userName)
            self.dbUser = try await UserManager.shared.getUser(userId: dbUser.userId)
            print("updated")
        }
    }
    
    func updateDateBirth(dateBirth: Date) {
        guard let dbUser else { return }
        Task {
            try await UserManager.shared.updateDateBirth(userId: dbUser.userId, date: dateBirth)
            self.dbUser = try await UserManager.shared.getUser(userId: dbUser.userId)
            print("updated")
        }
    }
    
    func loadCurrentDBUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.dbUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func loadCurrentDBUserPersonalData() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.dbUserPersonalData = try await UserManager.shared.getUserPersonalData(userId: authDataResult.uid)
    }
    
    func loadFriendDBUserPersonalData(id: String) async throws {
        self.friendDbUserPersonalData = try await UserManager.shared.getUserPersonalData(userId: id)
    }
    
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "test@google.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "111111"
        try await AuthenticationManager.shared.updateEmail(email: password)
    }
    
}
