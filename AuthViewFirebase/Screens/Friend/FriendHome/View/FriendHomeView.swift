//
//  FriendHomeView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 29.08.2023.
//

import SwiftUI

struct FriendHomeView: View {
    
    @StateObject private var viewModelSettings: SettingsViewModel = SettingsViewModel()
    @ObservedObject var viewModel: FriendHomeViewModel
    @State private var isButtonPressed = false
    @State private var isButtonPressedUnsubscribe = false
    @Environment(\.dismiss) var dismiss
    
    private var currentUserId: String {
        return try! AuthenticationManager.shared.getAuthenticatedUser().uid
    }
    
    var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    
    var body: some View {
        
        VStack {
            
            HeaderFriendCell(viewModel: viewModel)
            
            if viewModel.friend.userId == currentUserId {
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
                                   try await viewModel.deleteFriend(friendId: viewModel.friend.userId)
                                }
                                dismiss()
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
                                try await viewModel.stepOneForAddFriend(friendId: viewModel.friend.userId)
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
                                try await viewModel.stepTwoAnswerToRequestPositive(friendId: viewModel.friend.userId)
                            }
                            
                        } label: {
                            Text("Разрешить")
                        }
                        
                        Button {
                            
                            Task {
                                try await viewModel.stepTwoAnswerToRequestNegative(friendId: viewModel.friend.userId)
                            }
                        } label: {
                            Text("Отклонить")
                        }
                    }
                }
            }
        }
        .padding(.bottom, -6)
        .task {
            try? await viewModelSettings.loadFriendDBUserPersonalData(id: viewModel.friend.userId)
        }
        .navigationTitle(viewModel.friend.displayName ?? viewModelSettings.friendDbUserPersonalData?.userName ?? "")
        
        Divider()
            
        
        if viewModel.isFriendForFriendstArr && viewModel.isIamFriend {
            ScrollView {
                LazyVGrid (
                    columns: columns,
                    alignment: .center,
                    spacing: 15,
                    pinnedViews: [.sectionFooters]
                ) {
                    Section() {
                        ForEach(viewModel.wishlist) { present in
//                            NavigationLink {
//                                FriendPresentView(presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: FriendHomeViewModel(friend: viewModel.friend))
//                            } label: {
//                                PresentCellView(present: present)
//                            }
                            FriendPresentCellView(present: present, friend: viewModel.friend)
                        }
                    }
                }
            }
            .padding(.top, -8)
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
}
