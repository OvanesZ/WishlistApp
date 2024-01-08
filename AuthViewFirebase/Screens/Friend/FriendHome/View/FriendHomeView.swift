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
//    @ObservedObject var presentModelViewModel: PresentModelViewModel
    @State private var isButtonPressed = false
    
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
                            Task {
                               try await viewModel.deleteFriend(friendId: viewModel.friend.userId)
                            }
                        }, label: {
                            Text("Отписаться")
                                .font(.callout.bold())
                                .foregroundStyle(.white)
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
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
                        NavigationLink {
                            FriendPresentView(currentPresent: present, presentModelViewModel: PresentModelViewModel(present: present), friendViewModel: FriendHomeViewModel(friend: viewModel.friend))
                        } label: {
                            PresentCellView(present: present)
                        }
                        
                    }
                }
            }
        }
        .navigationTitle(viewModel.friend.displayName ?? viewModelSettings.friendDbUserPersonalData?.userName ?? "")
        .onAppear {
//            presentModelViewModel.getPresentImage()
//            presentModelViewModel.getUrlPresentImage()
        }
        
    }
}
