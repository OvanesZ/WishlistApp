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
    
    
    var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    init(friend: DBUser, viewModel: FriendHomeViewModel) {
        self.friend = friend
//        self._viewModel = ObservedObject(
//            wrappedValue: FriendHomeViewModel()
//        )
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
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
                                //                                PresentModalView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), currentList: nil)
                            } label: {
                                FriendPresentCellView(present: present, friend: self.friend)
                                //                                PresentCellView(present: present)
                            }
                        }
                    }
                }
                .padding(.top, -8)
                Spacer()
            }
            .navigationTitle("Общий список")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .bold()
                            Text("Назад")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.setupWishlistListener(userID: friend.userId)
        }
    }
    
}

#Preview {
    ListView()
}
