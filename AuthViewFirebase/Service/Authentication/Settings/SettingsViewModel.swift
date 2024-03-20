//
//  SettingsViewModel.swift
//  Wishlist
//
//  Created by Ованес Захарян on 07.12.2023.
//

import Foundation
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published private(set) var dbUser: DBUser? = nil
    @Published private(set) var dbUserPersonalData: PersonalDataDBUser? = nil
    @Published private(set) var friendDbUserPersonalData: PersonalDataDBUser? = nil
    @Published var image = UIImage(named: "person")!
    
    @Published var userName: String = ""
    @Published var userSername: String = ""
    @Published var dateBirth: Date = Date()
    @Published var url: URL?
    
//    let manager = CacheManager.instanse
    
    // MARK: - functions
    
    func getUrlUserImage() {
        StorageService.shared.downloadURLUserImage(id: AuthService.shared.currentUser?.uid ?? "") { result in
            switch result {
            case .success(let url):
                if let url = url {
                    self.url = url
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
//    func saveToCache(userIdForNameImage: String) {
//        manager.add(image: image, name: userIdForNameImage)
//    }
//    
//    func removeFromCache(userIdForNameImage: String) {
//        manager.remove(name: userIdForNameImage)
//    }
//    
//    func getImageFromCache(userIdForNameImage: String) {
//        self.image = manager.get(name: userIdForNameImage) ?? UIImage(named: "person")!
//    }
    
    func getUrlImageAsync() async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: AuthService.shared.currentUser?.uid ?? "")
    }
    
    func getUrlImageFriendAsync(id: String) async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: id)
    }
    
    func getImageAsync() async throws {
        Task {
            let data = try await StorageService.shared.downloadUserImageAsync(id: AuthService.shared.currentUser?.uid ?? "")
            if let img = UIImage(data: data) {
                self.image = img
            }
        }
    }
    
    func uploadImageAsync(userID: String) {
        let image = resizeImage(image: image, targetSize: CGSizeMake(472.0, 709.0))
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        Task {
            try await StorageService.shared.uploadAsync(id: userID, data: imageData)
        }
    }
    
    func updateUserName(userName: String, userSerName: String) {
        
        if let currenUserId = AuthService.shared.currentUser?.uid {
            UserManager.shared.updateUserName(userId: currenUserId, userName: userName, userSerName: userSerName)
        }
        
    }
    
    func updateDateBirth(dateBirth: Date) {
        if let currenUserId = AuthService.shared.currentUser?.uid {
            UserManager.shared.updateDateBirth(userId: currenUserId, date: dateBirth)
        }
    }
    
    func loadCurrentDBUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.dbUser = try await UserManager.shared.getUser(userId: authDataResult.uid)
        self.userName = dbUser?.userName ?? ""
        self.userSername = dbUser?.userSerName ?? ""
        self.dateBirth = dbUser?.dateBirth ?? Date()
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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        ImageLoader.shared.resizeImage(image: image, targetSize: targetSize)
   }
    
}



