//
//  FriendsCell.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI
import Kingfisher

struct FriendsCell: View {
    
    let friend: DBUser
    @State private var url: URL? = nil
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()
    @StateObject private var friendsViewModel: FriendsViewModel = FriendsViewModel()
    
    init(friend: DBUser) {
        self.friend = friend
    }
    
    var body: some View {
        
        
        HStack {
            
            KFImage(url)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            
            
            Text(friend.email ?? "")
                .padding(.leading, 3)
                .lineLimit(2)
                .bold()
            
            
        }
        .task {
            self.url = try? await viewModel.getUrlImageFriendAsync(id: friend.userId)
        }
        .onAppear {
            friendsViewModel.getFromCache(userIdForNameImage: friend.userId)
        }
        
    }
    
}

extension Text {
    func boldItalic() -> Text {
        self.bold().italic()
    }
}
