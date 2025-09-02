//
//  FriendHomeViewNew.swift
//  Wishlist
//
//  Created by Ованес Захарян on 24.08.2025.
//

import SwiftUI

struct FriendHomeViewNew: View {
    
    @StateObject var viewModel: FriendHomeViewModel = FriendHomeViewModel()
    @State private var isButtonPressed = false
    @State private var isButtonPressedUnsubscribe = false
    @Environment(\.dismiss) var dismiss
    @State private var isGoPresent = false
//    @State private var path = NavigationPath()
    
    var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    
    let friend: DBUser
    
    init(friend: DBUser) {
        self.friend = friend
    }
    
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                
                HeaderFriendCell(friend: friend, viewModel: viewModel)
                
                if friend.userId == AuthService.shared.currentUser?.uid {
                    Text("Ваша страница")
                        .font(.callout.italic())
                } else {
                    if viewModel.isFriendForFriendstArr {
                        
                        HStack {
                            Text("Вы подписаны")
                                .font(.callout.italic())
                            
                            Button(action: {
                                isButtonPressedUnsubscribe.toggle()
                            }, label: {
                                Text("Отписаться")
                                    .font(.callout.bold())
                                    .foregroundStyle(.white)
                                    .padding(.leading, 25)
                                    .padding(.trailing, 25)
                            })
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                            .confirmationDialog("Отписавшись, Вы закроете доступ к пожеланиям. Отписаться?", isPresented: $isButtonPressedUnsubscribe, titleVisibility: .visible) {
                                Button(role: .destructive) {
                                    
                                    Task {
                                        try await viewModel.deleteFriend(friendId: friend.userId)
                                        dismiss()
                                    }
                                    
                                } label: {
                                    Text("Да")
                                }
                                
                                Button {
                                    
                                    // TODO
                                    
                                } label: {
                                    Text("Нет")
                                }
                            }
                        }
                    } else {
                        
                        Button {
                            if viewModel.isFriendForRequestArr {
                                isButtonPressed.toggle()
                            } else {
                                
                                Task {
                                    try await viewModel.stepOneForAddFriend(friendId: friend.userId)
                                }
                            }
                        } label: {
                            Text(viewModel.isFriendForRequestArr ? "Ответить на запрос" : "Подписаться")
                                .font(.callout.bold())
                                .foregroundStyle(.white)
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .confirmationDialog("Ваши действия", isPresented: $isButtonPressed) {
                            Button {
                                
                                Task {
                                    try await viewModel.stepTwoAnswerToRequestPositive(friendId: friend.userId)
                                }
                                
                            } label: {
                                Text("Разрешить")
                            }
                            
                            Button {
                                
                                Task {
                                    try await viewModel.stepTwoAnswerToRequestNegative(friendId: friend.userId)
                                }
                            } label: {
                                Text("Отклонить")
                            }
                        }
                    }
                }
            }
            .padding(.bottom, -6)
            .navigationTitle(title())
            .onAppear {
                viewModel.isStopListener = false
                viewModel.isFriendOrNo(friend: friend)
            }
            
            Divider()
            
            /// Нижняя часть экрана друзей
            
            if viewModel.isFriendForFriendstArr && viewModel.isIamFriend || friend.userId == AuthService.shared.currentUser?.uid {
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.fixed(250))], spacing: 10) {
//                        Button {
//                            isGoPresent.toggle()
//                        } label: {
//                            VStack {
//                                Spacer()
//                                
//                                Text("Общий список")
//                                    .font(.title3.bold())
//                                    .foregroundStyle(.white)
//                                    .padding(.bottom, 28)
//                                    .padding(.trailing)
//                                
//                            }
//                            .frame(width: 170, height: 220)
//                            .background(
//                                
//                                RoundedRectangle(cornerRadius: 28)
//                                    .frame(width: 170, height: 220)
//                                    .overlay(
//                                        Image("presentList")
//                                            .resizable()
//                                            .frame(width: 170, height: 220)
//                                            .scaledToFill()
//                                            .cornerRadius(28)
//                                            .colorMultiply(.gray)
//                                    )
//                                
//                            )
//                        }
//                        .fullScreenCover(isPresented: $isGoPresent) {
//                            NavigationStack {
//                                FriendListView(friend: friend, viewModel: viewModel)
//                            }
//                            .presentationDetents([.large])
//                            .interactiveDismissDisabled(false)
//                        }
                        
                        NavigationLink {
                            FriendListView(friend: friend, viewModel: viewModel)
                        } label: {
                            VStack {
                                Spacer()
                                Text("Общий список")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                    .padding(.bottom, 28)
                                    .padding(.trailing)
                            }
                            .frame(width: 170, height: 220)
                            .background(
                                RoundedRectangle(cornerRadius: 28)
                                    .frame(width: 170, height: 220)
                                    .overlay(
                                        Image("presentList")
                                            .resizable()
                                            .frame(width: 170, height: 220)
                                            .scaledToFill()
                                            .cornerRadius(28)
                                            .colorMultiply(.gray)
                                    )
                            )
                        }
                        
                        
                        ForEach(viewModel.lists) { list in
                                NavigationLink {
                                    FriendUserListView(list: list, friend: friend, viewModel: viewModel)
                                } label: {
                                    ListCellView(list: list)
                                }
                        }
                    }
                    .padding(.leading, 8)
                }
                .onAppear {
                    viewModel.fetchList(friend: friend)
                    viewModel.setupWishlistListener(userID: friend.userId)
                }
                
                Spacer()
            } else {
                
                if viewModel.isFriendForFriendstArr {
                    Spacer()
                    
                    VStack {
                        Image(systemName: "lock")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.blue)
                        
                        Text("Запрос отправлен.")
                            .font(.callout.italic())
                            .foregroundStyle(.blue)
                        Text("Дождитесь ответа.")
                            .font(.subheadline.italic())
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                } else {
                    Spacer()
                    
                    VStack {
                        Image(systemName: "lock")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.blue)
                        
                        Text("Подпишитесь на пользователя.")
                            .font(.callout.italic())
                            .foregroundStyle(.blue)
                        Text("После Вы сможете видеть пожелания.")
                            .font(.subheadline.italic())
                            .foregroundStyle(.blue)
                    }
                    
                    Spacer()
                }
                
            }
            
        } // NavStackPath
    } // body
    
    func title() -> String {
        
        var title: String = ""
        
        if friend.userName == nil && friend.userSerName == nil {
            title = "\(friend.displayName ?? "")"
        } else {
            title = "\(friend.userName ?? "") \(friend.userSerName ?? "")"
        }
        
        return title
    }
    
}
