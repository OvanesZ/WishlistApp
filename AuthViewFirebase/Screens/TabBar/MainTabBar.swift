//
//  MainTabBar.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI

//struct MainTabBar: View {
//    
//    @StateObject private var friendsViewModel: FriendsViewModel = FriendsViewModel()
//    @Binding var showSignInView: Bool
//    
//    var body: some View {
//        
//      
//        
//        
//        TabView {
//            HomeViewNew()
//                .tabItem {
//                    VStack {
//                        Image(systemName: "rectangle.3.group")
//                        Text("Главная")
//                    }
//                }
//            FriendsView(friendViewModel: friendsViewModel)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "person.3.fill")
//                        Text("Друзья")
//                    }
//                }
//                .badge(friendsViewModel.myRequest.count)
//            
//            SettingView(showSignInView: $showSignInView)
//                .tabItem {
//                    VStack {
//                        Image(systemName: "gear")
//                        Text("Профиль")
//                    }
//                }
//        }
//    }
//}





// MARK: -- ---------------------------------- Новый TabBar ------------------------------------



enum Tab: String, Hashable, CaseIterable {
//    case home = "house"
//    case explore = "globe.europe.africa"
    case bookmark = "house"
    case notification = "person.3"
    case profile = "gearshape"
}

struct MainTabBar: View {

//    init() {
//        UITabBar.appearance().isHidden = true
//    }
    
    @State private var selectedTab: Tab = Tab.bookmark
    @StateObject private var friendsViewModel: FriendsViewModel = FriendsViewModel()
    @Binding var showSignInView: Bool
    
  var body: some View {
      ZStack(alignment: .bottom) {
          TabView(selection: $selectedTab) {
//              Text("HOME")
//                  .frame(maxWidth: .infinity, maxHeight: .infinity)
//                  .background(Color.red.opacity(0.5))
//                  .tag(Tab.home)
//              
//              Text("EXPLORE")
//                  .frame(maxWidth: .infinity, maxHeight: .infinity)
//                  .background(Color.yellow.opacity(0.5))
//                  .tag(Tab.explore)
              
//              Text("BOOKMARK")
//                  .frame(maxWidth: .infinity, maxHeight: .infinity)
//                  .background(Color.green.opacity(0.5))
              HomeViewNew()
                  .tag(Tab.bookmark)
              
//              Text("NOTIFICATION")
//                  .frame(maxWidth: .infinity, maxHeight: .infinity)
//                  .background(Color.green.opacity(0.5))
              FriendsView(friendViewModel: friendsViewModel)
                  .tag(Tab.notification)
              
              SettingView(showSignInView: $showSignInView)
                  .tag(Tab.profile)
          }
          CustomBottomTabBarView(currentTab: $selectedTab)
              .padding(.bottom)
      }
  }
}


private let buttonDimen: CGFloat = 55

struct CustomBottomTabBarView: View {
    
    @Binding var currentTab: Tab
    
    var body: some View {
        HStack {
        
//            TabBarButton(imageName: Tab.home.rawValue)
//                .frame(width: buttonDimen, height: buttonDimen)
//                .onTapGesture {
//                    currentTab = .home
//                }
//            
//            Spacer()
//
//            TabBarButton(imageName: Tab.explore.rawValue)
//                .frame(width: buttonDimen, height: buttonDimen)
//                .onTapGesture {
//                    currentTab = .explore
//                }
//
//            Spacer()
            
            TabBarButton(imageName: Tab.bookmark.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .bookmark
                }

            Spacer()
            
            TabBarButton(imageName: Tab.notification.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .notification
                }
            
            Spacer()
            
            TabBarButton(imageName: Tab.profile.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .profile
                }

        }
        .frame(width: (buttonDimen * CGFloat(Tab.allCases.count)) + 100)
        .tint(Color("textColor"))
        .padding(.vertical, 2.5)
        .background(Color("fillColor"))
        .clipShape(Capsule(style: .continuous))
        .overlay {
            SelectedTabCircleView(currentTab: $currentTab)
        }
        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 10)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.65), value: currentTab)
    }
    
}

private struct TabBarButton: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .renderingMode(.template)
            .tint(.black)
            .fontWeight(.bold)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomTabBarView(currentTab: .constant(.bookmark))
    }
}

struct SelectedTabCircleView: View {
    
    @Binding var currentTab: Tab
    
    private var horizontalOffset: CGFloat {
        switch currentTab {
//        case .home:
//            return -138
//        case .explore:
//            return -72
        case .bookmark:
            return -112
        case .notification:
            return 0
        case .profile:
            return 112
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("textColor"))
                .frame(width: buttonDimen , height: buttonDimen)
            
            TabBarButton(imageName: "\(currentTab.rawValue).fill")
                .foregroundColor(.white)
        }
        .offset(x: horizontalOffset)
    }

}

