//
//  FriendListView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 24.08.2025.
//

import SwiftUI

struct FriendListView: View {
    
    let friend: DBUser
    @ObservedObject var viewModel: FriendHomeViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var columns: [GridItem] {
        [
            GridItem(.fixed(150), spacing: 20),
            GridItem(.fixed(150), spacing: 20)
        ]
    }
    
    init(friend: DBUser, viewModel: FriendHomeViewModel) {
        self.friend = friend
        self.viewModel = viewModel
    }
    
    var body: some View {
            ScrollView {
                LazyVGrid (
                    columns: columns,
                    alignment: .center,
                    spacing: 15,
                    pinnedViews: [.sectionFooters]
                ) {
                    Section() {
                        
                        ForEach(viewModel.wishlist) { present in
                            NavigationLink {
                                FriendPresentView(friend: friend, presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: FriendHomeViewModel(), currentPresent: present)
                            } label: {
                                FriendPresentCellView(present: present, friend: friend)
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.setupWishlistListener(userID: friend.userId)
            }
            .background(
                Image("bglogo_wishlist")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.4)
                    .aspectRatio(contentMode: .fill)
                    .padding()
            )
            .navigationTitle("Общий список")
        
    }
}

#Preview {
    ListView()
}
