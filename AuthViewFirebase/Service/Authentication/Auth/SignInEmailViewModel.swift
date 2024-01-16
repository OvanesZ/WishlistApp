//
//  SignInEmailViewModel.swift
//  Wishlist
//
//  Created by Ованес Захарян on 30.11.2023.
//

import Foundation


@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isAlertShow = false
    @Published var alertMessage = ""
    @Published var isBindingShow = true
    
    
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        guard password == confirmPassword else {
            isAlertShow = true
            alertMessage = "Пароли не совпадают!"
            password = ""
            confirmPassword = ""
            return
        }
        do {
            let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.createNewUser(user: user)
            self.isBindingShow = false
        } catch {
            print(error.localizedDescription)
            alertMessage = error.localizedDescription
            isAlertShow.toggle()
            password = ""
            confirmPassword = ""
        }
        
        
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
