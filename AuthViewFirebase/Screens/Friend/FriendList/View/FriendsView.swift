//
//  SecondView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI
import Combine


struct FriendsView: View {
    
    @StateObject var friendViewModel: FriendsViewModel = FriendsViewModel()
    @ObservedObject var userViewModel: HomeViewModel
    @State var segmentedChoice = 0
    @State var nameFriend = ""
    @State var shouldShowCanselButton: Bool = true
    @FocusState var isFocus: Bool
    
    private let keyboardPublisher = Publishers.Merge(
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in true } ,
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { notification in false }
    ).eraseToAnyPublisher()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                VStack {
                    Picker("", selection: $segmentedChoice) {
                        Text("Подписки")
                            .tag(0)
                        Text("Подписчики")
                            .tag(1)
                        Text("Запросы (\(friendViewModel.myRequest.count))")
                            .tag(2)
                    }.padding([.leading, .trailing], 45).pickerStyle(SegmentedPickerStyle())
                    
                    
                    
                    // MARK: -- SubscribersView or SubscriptionsView and requestList
                    
                    if(segmentedChoice == 0) {
                        subscriptions
                    }
                    
                    if(segmentedChoice == 1) {
                        subscribers
                    }
                    
                    if(segmentedChoice == 2) {
                        requestList
                    }
                    
                }
            }
            .navigationTitle("Друзья")
        }
        .searchable(text: $nameFriend, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск друга").textInputAutocapitalization(.never)
        .onAppear(perform: friendViewModel.getRequest)
    }
}


extension FriendsView {
    
    private var subscriptions: some View {
     
        List {
            ForEach(self.nameFriend.isEmpty ? friendViewModel.myFriends : friendViewModel.allUsers.filter {
                self.nameFriend.isEmpty ? true : $0.email!.contains(nameFriend)
            }) { friend in
                NavigationLink {
                    FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", isReserved: false, presentDescription: "")))
                } label: {
                    FriendsCell(friend: friend)
                }
            }
            .onDelete { indexSet in
//                                let number = indexSet.first
//                                let email = friendViewModel.allFriendsUser[number ?? 0].email
//                                friendViewModel.allFriendsUser.remove(atOffsets: indexSet)
//                                friendViewModel.removingFriendFromFriends(email)
            }
        }
        .onAppear(perform: friendViewModel.fetchUsers)
        .onAppear(perform: friendViewModel.getFriends)
        .onAppear(perform: friendViewModel.getRequest)
        .listStyle(.inset)
    }
}


extension FriendsView {
    
    private var subscribers: some View {
        List {
            
            ForEach(friendViewModel.mySubscribers) { friend in
                
                NavigationLink {
                    FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(name: "", urlText: "", presentFromUserID: "")))
                } label: {
                    FriendsCell(friend: friend)
                }
            }
        }
        .listStyle(.inset)
        .onAppear(perform: friendViewModel.getFriends)
        .onAppear(perform: friendViewModel.getRequest)
        .onAppear(perform: friendViewModel.getMySubscribers)
    }
}


extension FriendsView {
    
    private var requestList: some View {
        
        List {
            ForEach(friendViewModel.myRequest) { friend in
                
                NavigationLink {
                    FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(name: "", urlText: "", presentFromUserID: "")))
                } label: {
                    FriendsCell(friend: friend)
                }
            }
        }
        .listStyle(.inset)
        .onAppear(perform: friendViewModel.getRequest)
    }
}
