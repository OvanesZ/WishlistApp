//
//  AuthService.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import Foundation
import FirebaseAuth
import Firebase

class AuthService {
    
    static let shared = AuthService()
    private init() { }
    private let auth = Auth.auth()
    var currentUser: User? {
        return auth.currentUser
    }
}

