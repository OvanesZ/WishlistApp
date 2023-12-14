//
//  SplashScreenView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 20.10.2023.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        
        if isActive {
//            if let user = AuthService.shared.currentUser {
//                let viewModel = MainTabBarViewModel(user: user)
//                MainTabBar(viewModel: viewModel)
//            } else {
//                AuthView()
//            }
            RootView()
        } else {
            ZStack {
                GeometryReader { geometry in
                    Image("bg_wishlist")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .aspectRatio(contentMode: .fill)
                        .font(.system(size: 80))
                }
                VStack {
                    Text("WISHLIST")
//                        .font(.largeTitle.bold()).underline()
                        .font(Font.custom("Gloock-Regular", size: 48))
                        .foregroundColor(.white)
                    
                    
                    
                    Image("logo_wishlist")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
        
        
        
    }
    
    
}

//struct SplashScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashScreenView()
//    }
//}
