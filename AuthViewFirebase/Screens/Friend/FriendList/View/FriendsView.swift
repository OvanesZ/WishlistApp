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
        
        NavigationStack {
            if friendViewModel.myFriends.isEmpty && nameFriend.isEmpty {
                
                VStack {
                    Spacer()
                    Text("Здесь будут Ваши подписки")
                        .foregroundStyle(.blue)
                        .font(.title2.bold().italic())
                    
                    Image("friends")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            
            List {
                
                
                
                if !nameFriend.isEmpty {
                    Text("Ваши подписки")
                        .font(.subheadline.italic())
                }
                
                
                ForEach(friendViewModel.myFriends) { friend in
                    NavigationLink {
                        FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", isReserved: false, presentDescription: "")))
                    } label: {
                        FriendsCell(friend: friend)
                    }
                }
                
                if !nameFriend.isEmpty {
                    Text("Глобальный поиск")
                        .font(.subheadline.italic())
                    
                    ForEach(friendViewModel.allUsers.filter {
                        self.nameFriend.isEmpty ? true : $0.email!.contains(nameFriend)
                    }) { friend in
                        NavigationLink {
                            FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", isReserved: false, presentDescription: "")))
                        } label: {
                            FriendsCell(friend: friend)
                        }
                    }
                }
                
            }
            .onAppear(perform: friendViewModel.fetchUsers)
            .onAppear(perform: friendViewModel.getMyFriendsID)
            .task {
                try? await friendViewModel.getFriendsAsync()
            }
            //        .onAppear(perform: friendViewModel.getFriends)
            .onAppear(perform: friendViewModel.getRequest)
            .listStyle(.inset)
        }
        
    }
}


extension FriendsView {
    
    private var subscribers: some View {
        
        NavigationStack {
            
            if friendViewModel.mySubscribers.isEmpty && nameFriend.isEmpty {
                
                VStack {
                    Spacer()
                    Text("Здесь будут Ваши подписчики")
                        .foregroundStyle(.blue)
                        .font(.title2.bold().italic())
                    
                    Image("friends")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            
            List {
                
                if !nameFriend.isEmpty {
                    Text("Ваши подписчики")
                        .font(.subheadline.italic())
                }
                
                ForEach(friendViewModel.mySubscribers) { friend in
                    
                    NavigationLink {
                        FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(name: "", urlText: "", presentFromUserID: "")))
                    } label: {
                        FriendsCell(friend: friend)
                    }
                }
                
                if !nameFriend.isEmpty {
                    Text("Глобальный поиск")
                        .font(.subheadline.italic())
                    
                    ForEach(friendViewModel.allUsers.filter {
                        self.nameFriend.isEmpty ? true : $0.email!.contains(nameFriend)
                    }) { friend in
                        NavigationLink {
                            FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", isReserved: false, presentDescription: "")))
                        } label: {
                            FriendsCell(friend: friend)
                        }
                    }
                }
                
                
                
                
            }
            .listStyle(.inset)
            //        .onAppear(perform: friendViewModel.getFriends)
            .onAppear(perform: friendViewModel.getRequest)
            .onAppear(perform: friendViewModel.getMySubscribers)
        }
        
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
