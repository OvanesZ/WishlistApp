//
//  SecondView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI
import Combine


struct FriendsView: View {
    
    @ObservedObject var friendViewModel: FriendsViewModel
//    @ObservedObject var userViewModel: HomeViewModel
    @State var segmentedChoice = 0
    @State var nameFriend = ""
//    @State var shouldShowCanselButton: Bool = true
//    @FocusState var isFocus: Bool
//    
//    @State var isEditing = false
    
    private let keyboardPublisher = Publishers.Merge(
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification in true } ,
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { notification in false }
    ).eraseToAnyPublisher()
    
    var body: some View {
        
        NavigationStack {
//            SearchBarView(text: $nameFriend, isEditing: $isEditing)
            ZStack {
                VStack {
                    Picker("", selection: $segmentedChoice) {
                        Text("Подписки")
                            .tag(0)
                        Text("Подписчики")
                            .tag(1)
                        Text("Запросы (\(friendViewModel.myRequest.count))")
                            .tag(2)
                    }
                    .padding([.leading, .trailing], 45)
//                    .pickerStyle(SegmentedPickerStyle())
                    .pickerStyle(.segmented)
                   
                    
                    
                    
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        friendViewModel.test()
                        print("testBadge = \(friendViewModel.testBadge)")
                    } label: {
                        Text("TEST")
                            .font(.title.bold())
                            .foregroundStyle(.red)
                    }

                }
            }
//            .toolbar(isEditing ? .hidden : .visible, for: .navigationBar).animation(.linear(duration: 0.25))
//            .navigationBarHidden(isEditing).animation(.linear(duration: 0.25))
        }
        .searchable(text: $nameFriend, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск друга")
       
//        .textInputAutocapitalization(.none)
        
        
//        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//            .onEnded({ value in
//                if value.translation.width < 0 {
//                    if segmentedChoice == 0 {
//                        segmentedChoice = 0
//                    } else if segmentedChoice == 1 {
//                        segmentedChoice = 0
//                    } else if segmentedChoice == 2 {
//                        segmentedChoice = 1
//                    }
//                }
//                
//                if value.translation.width > 0 {
//                    // right
//                }
//            })
//        )
    }
}


extension FriendsView {
    
    private var subscriptions: some View {
        
        NavigationStack {
            
            if friendViewModel.isLoading {
                ProgressView()
            } else {
                if friendViewModel.myFriends.isEmpty && nameFriend.isEmpty {

                    VStack {
//                        Spacer()
                        Text("Здесь будут Ваши подписки")
                            .foregroundStyle(.blue)
                            .font(.title2.bold().italic())
                        
                        Image("friends")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .animation(Animation.easeInOut(duration: 0.9), value: friendViewModel.isLoading)
                }
            }
            
            List {
                if !nameFriend.isEmpty {
                    if friendViewModel.myFriends.isEmpty {
                        Text("У Вас пока нет подписок")
                            .font(.subheadline.italic())
                            .padding()
                    } else {
                        Text("Ваши подписки")
                            .font(.subheadline.italic())
                            .padding()
                    }
                }
                
                
                ForEach(friendViewModel.myFriends) { friend in
                    NavigationLink {
                        FriendHomeView(viewModel: FriendHomeViewModel(friend: friend))
                    } label: {
                        FriendsCell(friend: friend)
                    }
                }
                
                if !nameFriend.isEmpty {
                    
                    HStack {
                        Text("Глобальный поиск")
                            .font(.subheadline.italic())
                            .padding()
                            
                        Image(systemName: "network")
                            .foregroundStyle(.blue)
                            .font(.title2.bold())
                            .overlay {
                                SkeletonClearView()
                                    .clipShape(Circle())
                                    .frame(width: 70, height: 70, alignment: .center)
                            }
                    }
                    .padding(.top, 35)
                    
                    ForEach(friendViewModel.allUsers.filter {
                        if let userName = $0.userName {
                            return self.nameFriend.isEmpty ? true : userName.contains(nameFriend)
                        }
                        return self.nameFriend.isEmpty
                        /// Если при тестировании выявятся ошибки, ниже строка, которая без развертывания работала успешно (вместе 4х строк выше)
//                        self.nameFriend.isEmpty ? true : $0.email!.contains(nameFriend)
                    }) { friend in
                        NavigationLink {
                            FriendHomeView(viewModel: FriendHomeViewModel(friend: friend))
                        } label: {
                            FriendsCell(friend: friend)
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .task {
                try? await friendViewModel.getMyFriendsID()
                try? await friendViewModel.getSubscriptions()
                try? await friendViewModel.getAllUsers()
                
                try? await friendViewModel.getMyRequestID()
                try? await friendViewModel.getRequest()
            }
            .listStyle(.inset)
        }
        .refreshable {
            Task {
                try? await friendViewModel.getMyFriendsID()
                try? await friendViewModel.getSubscriptions()
                try? await friendViewModel.getAllUsers()
                
                try? await friendViewModel.getMyRequestID()
                try? await friendViewModel.getRequest()
            }
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
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            List {
                
                if !nameFriend.isEmpty {
                    if friendViewModel.mySubscribers.isEmpty {
                        Text("У Вас пока нет подписчиков")
                            .font(.subheadline.italic())
                            .padding()
                    } else {
                        Text("Ваши подписчики")
                            .font(.subheadline.italic())
                            .padding()
                    }
                }
                
                ForEach(friendViewModel.mySubscribers) { friend in
                    
                    NavigationLink {
                        FriendHomeView(viewModel: FriendHomeViewModel(friend: friend))
                    } label: {
                        FriendsCell(friend: friend)
                    }
                }
                
                if !nameFriend.isEmpty {
                    HStack {
                        Text("Глобальный поиск")
                            .font(.subheadline.italic())
                            .padding()
                            
                        Image(systemName: "network")
                            .foregroundStyle(.blue)
                            .font(.title2.bold())
                            .overlay {
                                SkeletonClearView()
                                    .clipShape(Circle())
                                    .frame(width: 70, height: 70, alignment: .center)
                            }
                    }
                    .padding(.top, 35)
                    
                    ForEach(friendViewModel.allUsers.filter {
                        if let userName = $0.userName {
                            return self.nameFriend.isEmpty ? true : userName.contains(nameFriend)
                        }
                        return self.nameFriend.isEmpty
                    }) { friend in
                        NavigationLink {
                            FriendHomeView(viewModel: FriendHomeViewModel(friend: friend))
                        } label: {
                            FriendsCell(friend: friend)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .scrollDismissesKeyboard(.immediately)
            .task {
                try? await friendViewModel.getMySubscribersID()
                try? await friendViewModel.getSubscribers()
            }
        }
        .refreshable {
            Task {
                try? await friendViewModel.getMySubscribersID()
                try? await friendViewModel.getSubscribers()
            }
        }
        
    }
}


extension FriendsView {
    
    private var requestList: some View {
        
        List {
            ForEach(friendViewModel.myRequest) { friend in
                
                NavigationLink {
                    FriendHomeView(viewModel: FriendHomeViewModel(friend: friend))
                } label: {
                    FriendsCell(friend: friend)
                }
            }
        }
        .listStyle(.inset)
        .scrollDismissesKeyboard(.immediately)
        .refreshable {
            Task {
                try? await friendViewModel.getMyRequestID()
                try? await friendViewModel.getRequest()
            }
        }
    }
}
