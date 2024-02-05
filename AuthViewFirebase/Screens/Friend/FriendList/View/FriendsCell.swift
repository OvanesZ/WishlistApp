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
            
//            KFImage(url)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 60, height: 60)
//                .clipShape(Circle())
            
            
            AsyncImage(
                url: url,
                transaction: Transaction(animation: .linear)
            ) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
//                                    .transition(.scale(scale: 0.1, anchor: .center))
                case .failure:
                    Image(systemName: "wifi.slash")
                @unknown default:
                    EmptyView()
                }
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
