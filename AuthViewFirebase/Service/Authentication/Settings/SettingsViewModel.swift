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
    @Published var image = UIImage(named: "person")!
    @Published var isLoadImage = false
    @Published var url: URL?
    @Published var user: PersonalDataDBUser? = nil
    
    
    // MARK: - functions
    
    
    func updateUrlImage(url: String) {
        Task {
            try await UserManager.shared.updateUrlImage(userId: dbUserPersonalData?.userId ?? "", url: url)
            self.dbUserPersonalData = try await UserManager.shared.getUserPersonalData(userId: dbUserPersonalData?.userId ?? "")
            print("url updated")
        }
    }
    
    func getUrlImageAsync() {
        Task {
            self.url = try await StorageService.shared.downloadURLUserImageAsync(id: dbUserPersonalData?.userId ?? "")
            updateUrlImage(url: url?.absoluteString ?? "")
        }
    }
    
//    func getUrlImage() {
//        StorageService.shared.downloadURLUserImage(id: dbUserPersonalData?.userId ?? "") { result in
//            switch result {
//            case .success(let url):
//                if let url = url {
//                    self.url = url
//                    self.updateUrlImage(url: url.absoluteString)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func getImageAsync() async throws {
        Task {
            let data = try await StorageService.shared.downloadUserImageAsync(id: dbUserPersonalData?.userId ?? "")
            if let img = UIImage(data: data) {
                self.image = img
            }
        }
    }
    
//    func getImage() {
//        self.isLoadImage = true
//        StorageService.shared.downloadUserImage(id: dbUserPersonalData?.userId ?? "") { result in
//            switch result {
//            case .success(let data):
//                self.isLoadImage = false
//                if let img = UIImage(data: data) {
//                    self.image = img
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func uploadImageAsync() {
        guard let imageData = image.jpegData(compressionQuality: 0.15) else { return }
        Task {
            try await StorageService.shared.uploadAsync(id: dbUserPersonalData?.userId ?? "", data: imageData)
        }
    }
    
//    func uploadImage() {
//        guard let imageData = image.jpegData(compressionQuality: 0.15) else { return }
//        StorageService.shared.upload(id: dbUserPersonalData?.userId ?? "", image: imageData) { result in
//            switch result {
//            case .success(let sizeInfo):
//                print(sizeInfo)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func updateUserName(userName: String) {
        guard let dbUser else { return }
        Task {
            try await UserManager.shared.updateUserName(userId: dbUser.userId, userName: userName)
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
