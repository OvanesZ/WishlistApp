//
//  FriendUserListView.swift
//  Wishlist
//
//  Created by Ованес Захарян on 26.08.2025.
//

import SwiftUI
//
//struct FriendUserListView: View {
//    
//    let list: ListModel
//    let friend: DBUser
//    
//  
//    @StateObject private var viewModel = FriendHomeViewModel()
//    @Environment(\.dismiss) var dismiss
//    
//    public init(list: ListModel, friend: DBUser) {
//        self.list = list
//        self.friend = friend
//    }
//    
//    
//    private var columns: [GridItem] = [
//        GridItem(.fixed(150), spacing: 20),
//        GridItem(.fixed(150), spacing: 20)
//    ]
//    
//    
//    
//    var body: some View {
////        NavigationStack {
////            ZStack {
//                // MARK: -- LazyVGrid
//                
////                ScrollView {
////                    LazyVGrid(
////                        columns: columns,
////                        alignment: .center, // позволяет нам выровнять содержимое сетки с помощью перечисления HorizontalAlignment для LazyVGrid и VerticalAlignment для LazyHGrid. Работает так же, как stack alignment
////                        spacing: 15, // расстояние между каждой строкой внутри
////                        pinnedViews: [.sectionFooters]
////                    ) {
////                        Section() {
////                            ForEach(viewModel.wishlist) { present in
////                                NavigationLink {
////                                    PresentModalView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), currentList: list)
////                                } label: {
////                                    PresentCellView(present: present)
////                                }
////                            }
////                        }
////                    }
////                }
////                .onAppear {
////                    viewModel.isStopListener = false
////                    viewModel.fetchOtherWishlist(list: list, friend: friend)
////                }
////                .onDisappear {
////                    viewModel.isStopListener = true
////                    viewModel.fetchOtherWishlist(list: list, friend: friend)
////                }
////                .background(
////                    Image("bglogo_wishlist")
////                    .resizable()
////                    .scaledToFit()
////                    .opacity(0.4)
////                    .aspectRatio(contentMode: .fill)
////                    .padding()
////                )
////                .navigationTitle(list.name)
////            }
//                
//                Text("HELLO")
//                    .font(.largeTitle)
//            
////        }
//    }
//}


struct FriendUserListView: View {
    let list: ListModel
    let friend: DBUser
    
    var columns: [GridItem] {
        [
            GridItem(.fixed(150), spacing: 20),
            GridItem(.fixed(150), spacing: 20)
        ]
    }

    @StateObject private var viewModel = FriendHomeViewModel()
    
    init(list: ListModel, friend: DBUser) {
        self.list = list
        self.friend = friend
        _viewModel = StateObject(wrappedValue: FriendHomeViewModel())
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
                            FriendPresentView(friend: friend, presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: FriendHomeViewModel(), currentPresent: present)
                        } label: {
                            FriendPresentCellView(present: present, friend: friend)
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
            // .onDisappear { viewModel.stopListener() }
    }
}



// 1. Доработать выбор подарка в листах (не общий список) Нужно прыгать в конкретный лист
// 2. Проверить работает ли открытие оплаты у не премиум аккаунта при нажатии выбрать подарок
// 3. Изменить FriendListView на NavigationLink
