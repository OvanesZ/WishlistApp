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
    @Binding var showSignInView: Bool
    
    
    var body: some View {
        
        TabView {
//            HomeView(viewModel: HomeViewModel())
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.3.group")
                        Text("Главная")
                    }
                }
            FriendsView(userViewModel: HomeViewModel())
//            FriendsView(friendViewModel: FriendsViewModel(friend: UserModel(id: "", email: "", displayName: "", address: "", dateOfBirth: Date())), userViewModel: HomeViewModel())
                .tabItem {
                    VStack {
                        Image(systemName: "person.3.sequence")
                        Text("Друзья")
                    }
                }
                .badge(1)
    
            ProfileView(viewModel: ProfileViewModel(profile: UserModel(id: "", email: "", displayName: "", address: "", dateOfBirth: Date())), showSignInView: $showSignInView)
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Профиль")
                    }
                }
            
            SettingView(showSignInView: $showSignInView)
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Профиль NEW")
                    }
                }
            
        }
        
        
    }
    
    
}


