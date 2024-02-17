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
                
//                if UserDefaults.standard.bool(forKey: "NewUser") == true {
//                    CreateNameView(showSignInView: $showSignInView)
//                } else {
//                    MainTabBar(showSignInView: $showSignInView)
//                }
                let user = try? AuthenticationManager.shared.getAuthenticatedUser()
                
                if UserDefaults.standard.bool(forKey: user?.uid ?? "") == true || UserDefaults.standard.bool(forKey: "NewUser") == true {
                    CreateNameView(showSignInView: $showSignInView)
                } else {
                    MainTabBar(showSignInView: $showSignInView)
                }
              
                
                
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
//            .tint(Color(.backButton))
          
            // сброс клавиатуры
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        
        
    }
}

//struct RootView_Previews: PreviewProvider {
//    static var previews: some View {
//        RootView()
//    }
//}
