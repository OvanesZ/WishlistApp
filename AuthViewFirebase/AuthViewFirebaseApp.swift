//
//  AuthViewFirebaseApp.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 19.08.2023.
//

import SwiftUI
import Firebase

@main
struct AuthViewFirebaseApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            
            SplashScreenView()
            
//            if let user = AuthService.shared.currentUser {
//                let viewModel = MainTabBarViewModel(user: user)
//                MainTabBar(viewModel: viewModel)
//            } else {
//                AuthView()
//            }
            
            
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            FirebaseApp.configure()
            print("App Delegate Did lainching")
            return true
        }
    }
    
}
