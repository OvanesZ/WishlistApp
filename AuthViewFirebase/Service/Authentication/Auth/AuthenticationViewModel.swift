//
//  AuthenticationViewModel.swift
//  Wishlist
//
//  Created by Ованес Захарян on 30.11.2023.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    @Published var allUsers: [DBUser] = []
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        
        for userr in allUsers {
            if user.userId == userr.userId {
                UserDefaults.standard.setValue(false, forKey: user.userId)
                UserDefaults.standard.setValue(false, forKey: "NewUser")
                return
            } else {
                UserDefaults.standard.setValue(true, forKey: user.userId)
                UserDefaults.standard.setValue(false, forKey: "NewUser")
            }
        }
        
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        
        for userr in allUsers {
            if user.userId == userr.userId {
                UserDefaults.standard.setValue(false, forKey: user.userId)
                UserDefaults.standard.setValue(false, forKey: "NewUser")
                return
            } else {
                UserDefaults.standard.setValue(true, forKey: user.userId)
                UserDefaults.standard.setValue(false, forKey: "NewUser")
            }
        }
        
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func getAllUsers() async throws {
        self.allUsers = try await DatabaseService.shared.getAllUsers().documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
}
