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
    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @State private var isButtonPressed = false
    
    var columns: [GridItem] = [
        GridItem(.fixed(150), spacing: 20),
        GridItem(.fixed(150), spacing: 20)
    ]
    
    
    var body: some View {
        
        VStack {
            
            HeaderFriendCell(viewModel: viewModel)
            
            Divider()
                .padding([.leading, .trailing], 25)
            
            
            
            if viewModel.isFriendForFriendstArr {
                Text("Вы подписаны")
            } else {
                Button {
                    if viewModel.isFriendForRequestArr {
                        isButtonPressed.toggle()
                    } else {
//                        viewModel.loadNewFriendInCollection(viewModel.friend)
                        
                        // 1.
                        Task {
                            try await viewModel.stepOneForAddFriend(friendId: viewModel.friend.userId)
                        }
                    }
                } label: {
                    Text(viewModel.isFriendForRequestArr ? "Ответить на запрос" : "Подписаться")
                }
                .buttonStyle(.bordered)
                .confirmationDialog("Ваши действия", isPresented: $isButtonPressed) {
                    Button {
//                        viewModel.answerToRequestAllow()
                        
                        // 2.
                        Task {
                            try await viewModel.stepTwoAnswerToRequestPositive(friendId: viewModel.friend.userId)
                        }
                        
                    } label: {
                        Text("Разрешить")
                    }
                    
                    Button {
//                        viewModel.answerToRequestReject()
                        
                        // 3.
                        Task {
                            try await viewModel.stepTwoAnswerToRequestNegative(friendId: viewModel.friend.userId)
                        }
                    } label: {
                        Text("Отклонить")
                    }
                }
            }
            
            
            
            
        }
        .task {
            try? await viewModelSettings.loadFriendDBUserPersonalData(id: viewModel.friend.userId)
        }
            
            
            ScrollView {
                LazyVGrid (
                    columns: columns,
                    alignment: .center,
                    spacing: 15,
                    pinnedViews: [.sectionFooters]
                ) {
                    Section() {
                        ForEach(viewModel.wishlist) { present in
                            FriendPresentsMainView(present: present, friendHomeViewModel: viewModel)
                        }
                    }
                }
            }
            .navigationTitle(viewModel.friend.displayName ?? viewModelSettings.friendDbUserPersonalData?.userName ?? "")
            .onAppear {
                presentModelViewModel.getPresentImage()
            }
        
    }
}
