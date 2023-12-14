//
//  ProfileViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import Foundation
import Combine
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    // MARK: - @Published
    
    @Published var profile: UserModel
    @Published var image = UIImage(named: "person")!
    @Published var isLoadImage = false


    // MARK: - init()
    
    init(profile: UserModel) {
        self.profile = profile
    }
    
    // MARK: - func()
    
    // Загружаю данные пользователя и аватарку в Firebase
    
    func setProfile() {
        
        guard let imageData = image.jpegData(compressionQuality: 0.15) else { return }
        
        DatabaseService.shared.setProfile(user: profile, image: imageData) { result in
            switch result {
            case .success(let user):
                print(user.displayName)
            case .failure(let error):
                print("Ошибка при отправке данных на сервер \(error.localizedDescription)")
            }
        }
    }
    
    // Получаю данные пользователя
    
    func getProfile() {
        
        DatabaseService.shared.getProfile { result in
            switch result {
            case .success(let user):
                self.profile = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // Получаю аватарку пользователя
    
    func getImage() {
        
        self.isLoadImage = true
        
        if let user = AuthService.shared.currentUser {
            StorageService.shared.downloadUserImage(id: user.uid) { result in
                switch result {
                case .success(let data):
                    self.isLoadImage = false
                    if let img = UIImage(data: data) {
                        self.image = img
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            return
        }
    }
    
    // Выход из аккаунта
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    
}
