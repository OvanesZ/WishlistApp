//
//  SecondView.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 20.08.2023.
//

import SwiftUI
import Combine


struct FriendsView: View {
    
//    @ObservedObject var friendViewModel: FriendsViewModel
    @StateObject var friendViewModel: FriendsViewModel = FriendsViewModel()
    @ObservedObject var userViewModel: HomeViewModel
    @State var segmentedChoice = 0
    @State var nameFriend = ""
    @State var shouldShowCanselButton: Bool = true
    @FocusState var isFocus: Bool
    
//    init(friendViewModel: FriendsViewModel, userViewModel: HomeViewModel) {
//        self.friendViewModel = friendViewModel
//        self.userViewModel = userViewModel
//    }
    
  
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
                    
                    
                    
                    // MARK: -- SubscribersView or SubscriptionsView
                    
                    if(segmentedChoice == 0) {
                        
                        // MARK: - Show user friends in List
                        
                        List {
                            ForEach(self.nameFriend.isEmpty ? friendViewModel.myFriends : friendViewModel.allUsers.filter {
                                self.nameFriend.isEmpty ? true : $0.email.contains(nameFriend)
                            }) { friend in
                                
                                NavigationLink {
                                    FriendHomeView(viewModel: FriendHomeViewModel(friend: friend), presentModelViewModel: PresentModelViewModel(present: PresentModel(id: "", name: "", urlText: "", presentFromUserID: "", isReserved: false, presentDescription: "")))
                                } label: {
                                    FriendsCell(friend: friend)
                                }
//                                .listRowSeparatorTint(Color(#colorLiteral(red: 0.04370719939, green: 0.1099352911, blue: 0.1132253781, alpha: 1)))
//                                .listRowSeparator(.visible)
                                
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
                            
                        
                        // MARK: - end List
                    }
                    if(segmentedChoice == 1) {
                        
                        List {
                            ForEach(friendViewModel.allUsers) { friend in
                                
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
                    }
                    if(segmentedChoice == 2) {
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
            }
            .navigationTitle("Друзья")
            
        }
        .searchable(text: $nameFriend, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск друга").textInputAutocapitalization(.never)
        .onAppear(perform: friendViewModel.getRequest)
        
        
        
        
        
    }
}
