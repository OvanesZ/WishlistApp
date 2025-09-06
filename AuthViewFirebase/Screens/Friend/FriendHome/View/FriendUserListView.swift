//
//  FriendUserListView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 26.08.2025.
//

import SwiftUI

struct FriendUserListView: View {
    let list: ListModel
    let friend: DBUser
    @ObservedObject var viewModel: FriendHomeViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var columns: [GridItem] {
        [
            GridItem(.fixed(150), spacing: 20),
            GridItem(.fixed(150), spacing: 20)
        ]
    }
    
    init(list: ListModel, friend: DBUser, viewModel: FriendHomeViewModel) {
        self.list = list
        self.friend = friend
        self.viewModel = viewModel
    }

    var body: some View {
        
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center, // позволяет нам выровнять содержимое сетки с помощью перечисления HorizontalAlignment для LazyVGrid и VerticalAlignment для LazyHGrid. Работает так же, как stack alignment
                spacing: 15, // расстояние между каждой строкой внутри
                pinnedViews: [.sectionFooters]
            ) {
                Section() {
                    ForEach(viewModel.wishlist) { present in
                        NavigationLink {
                            PresentViewOtherList(friend: friend, presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: viewModel, currentPresent: present, list: list)
                        } label: {
                            PresentCellViewOtherList(present: present, friend: friend, list: list)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.setupListener()
            viewModel.fetchOtherWishlist(list: list, friend: friend)
        }
        .background(
            Image("bglogo_wishlist")
                .resizable()
                .scaledToFit()
                .opacity(0.4)
                .aspectRatio(contentMode: .fill)
                .padding()
        )
        .navigationTitle(list.name)
    }
}



// 2. Проверить работает ли открытие оплаты у не премиум аккаунта при нажатии выбрать подарок
