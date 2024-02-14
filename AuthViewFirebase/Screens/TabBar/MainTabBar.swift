//
//  MainTabBar.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI

struct MainTabBar: View {
    
    @StateObject private var friendsViewModel: FriendsViewModel = FriendsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
      
        
        
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.3.group")
                        Text("Главная")
                    }
                }
            FriendsView(friendViewModel: friendsViewModel)
                .tabItem {
                    VStack {
                        Image(systemName: "person.3.fill")
                        Text("Друзья")
                    }
                }
                .badge(friendsViewModel.testBadge)
            
            SettingView(showSignInView: $showSignInView)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Профиль")
                    }
                }
//                .badge("NEW")
        }
        
        
        
        
    }
    
    
}


