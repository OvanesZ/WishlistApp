//
//  MainTabBar.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI

struct MainTabBar: View {
    
//    @StateObject var viewModel: MainTabBarViewModel = MainTabBarViewModel()
    
//    @State var showSignInView = false
//    @StateObject private var friendsViewModel: FriendsViewModel = FriendsViewModel()
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
            FriendsView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.3.sequence")
                        Text("Друзья")
                    }
                }
//                .task {
//                    try? await friendsViewModel.getMyRequestID()
//                    try? await friendsViewModel.getRequest()
//                }
//                .badge(friendsViewModel.myRequest.count)
            
            SettingView(showSignInView: $showSignInView)
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Профиль NEW")
                    }
                }
                .badge("NEW")
        }
        
        
        
    }
    
    
   
    
    
}


