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
            
            
            VStack {
                HStack {
                    Text(friend.displayName ?? viewModel.friendDbUserPersonalData?.userName ?? "")
                        .font(.system(.headline, design: .rounded))
                    
                    Spacer()
                }
                
                
                HStack {
                    if let date = viewModel.friendDbUserPersonalData?.dateBirth {
                        Text("\(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(Color.gray)
                    }
                    
                    Spacer()
                }
             
            }
            
            
            
        }
        .task {
            self.url = try? await viewModel.getUrlImageFriendAsync(id: friend.userId)
            try? await viewModel.loadFriendDBUserPersonalData(id: friend.userId)
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
