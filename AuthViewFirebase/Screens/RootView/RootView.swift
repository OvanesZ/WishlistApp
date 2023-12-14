//
//  RootView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 18.11.2023.
//

import SwiftUI
import FirebaseAuth

struct RootView: View {
    
    @State private var showSignInView = false
    
    var body: some View {
        
        ZStack {
            if !showSignInView {
                
//                if let user = Auth.auth().currentUser {
//                    let viewModel = MainTabBarViewModel(user: user)
//                    MainTabBar(viewModel: viewModel, showSignInView: showSignInView)
//                } else {
//                    AuthenticationView(showSignInView: $showSignInView)
//                }
                
                MainTabBar(showSignInView: $showSignInView)
                
            }
        }
        .onAppear {
            let authuser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authuser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        
        
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
