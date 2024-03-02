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
    @ObservedObject private var friendsViewModel: FriendsViewModel = FriendsViewModel()
    
    init(friend: DBUser) {
        self.friend = friend
    }
    
    var body: some View {
        
        
        HStack {
            
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            
            
            
            VStack {
                HStack {
                    Text(friend.userName ?? "")
                        .font(.system(.headline, design: .rounded))
                    
                    Spacer()
                }
                
                
                HStack {
                    if let date = friend.dateBirth {
                        Text("\(date.formatted(.dateTime.day().month().year().locale(Locale(identifier: "ru_RU"))))")
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(Color.gray)
                    }
                    
                    Spacer()
                }
             
            }
            
            
            
        }
        .task {
            self.url = try? await friendsViewModel.getUrlImageFriendAsync(id: friend.userId)
//            try? await viewModel.loadFriendDBUserPersonalData(id: friend.userId)
        }
        
    }
    
}

extension Text {
    func boldItalic() -> Text {
        self.bold().italic()
    }
}
