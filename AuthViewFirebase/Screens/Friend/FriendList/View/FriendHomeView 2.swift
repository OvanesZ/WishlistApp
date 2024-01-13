//
//  FriendHomeView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI

struct FriendHomeView: View {
    
    @ObservedObject var viewModel: FriendsViewModel
    
    var body: some View {
        
       
        VStack {
            Text("Экран пользователя")
            
            Button {
                viewModel.loadNewFriendInCollection(viewModel.friend)
            } label: {
                Text("Подписаться")
            }
            .buttonStyle(.bordered)
        }
        
      

        
    }
}

//struct FriendHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendHomeView()
//    }
//}
