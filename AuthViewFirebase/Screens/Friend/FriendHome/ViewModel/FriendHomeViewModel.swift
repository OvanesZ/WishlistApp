//
//  FriendHomeViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 03.09.2023.
//

import Foundation
import FirebaseFirestore


class FriendHomeViewModel: ObservableObject {
    
    @Published var myFriends: [DBUser] = []
    @Published var allUsers: [DBUser] = []
    @Published var mySubscribers: [DBUser] = []
    @Published var myRequest: [DBUser] = []
    @Published var allFriendsUser: [DBUser] = []
    @Published var myFriendsID: [String] = [" "]
    @Published var isLoading = false
    @Published var uiImage: UIImage? = nil
    @Published var isLoadImage = false
    
    private var myRequestID: [String] = [" "]
    private var mySubscribersID: [String] = [" "]
    
    
    @Published var isOtherWishlistLoaded = false
    
    
    @Published var wishlist: [PresentModel] = []
    @Published var isFriendForRequestArr = false
    @Published var isFriendForFriendstArr = false
    @Published var isIamFriend = false
    @Published var isStopListener = false
    @Published private(set) var dbUser: DBUser? = nil
    private var listener: ListenerRegistration?
    private var wishlistListener: ListenerRegistration?
    
    
    @Published var lists: [ListModel] = [] // будет содержать все списки пользователя
    
    init() {
        setupListener()
        Task {
            try? await getMyRequestID()
            try? await getRequest()
        }
    }
    
    deinit {
        stopListener()
        stopWishlistListener()
    }
    
    // MARK: -- Прослушиватель обновлений коллекции list. (пишет все данные в переменную list)
    
    func fetchList(friend: DBUser) {
        
        if AuthService.shared.currentUser != nil {
            let docRef = Firestore.firestore().collection("users").document(friend.userId).collection("list")
           
            let listener = docRef.addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.lists = snapshot?.documents.compactMap {
                    try? $0.data(as: ListModel.self)
                } ?? []
            }
            if isStopListener {
                listener.remove()
                lists = []
            }
            
        } else {
            return
        }
    }
    
    func getUrlListImage(listId: String) async throws -> URL {
        try await StorageService.shared.downloadURLListImageAsync(id: listId)
    }
    
    func fetchOtherWishlist(list: ListModel, friend: DBUser) {
        
        if AuthService.shared.currentUser != nil {
            let docRef = Firestore.firestore().collection("users").document(friend.userId).collection("list").document(list.id).collection("otherWishlist")
           
            let listener = docRef.addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.wishlist = snapshot?.documents.compactMap {
                    try? $0.data(as: PresentModel.self)
                } ?? []
            }
            if isStopListener {
                listener.remove()
                wishlist = []
            }
            
        } else {
            return
        }
        
    }
    
    // Получаю данные юзера с базы для определения премиум статуса
    
    func setupListener() {
        
        
        guard let uid = AuthService.shared.currentUser?.uid, !uid.isEmpty else {
            print("нет допустимого UID пользователя")
            return
        }
        
        listener = Firestore.firestore().collection("users").document(uid).addSnapshotListener { docSnapshot, error in
            guard let document = docSnapshot else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            let source = document.metadata.hasPendingWrites ? "Local" : "Server"
            print("\(source) data: \(document.data() ?? [:])")
            let data = try? document.data(as: DBUser.self)
            self.dbUser = data
        }
    }
    
    func stopListener() {
        listener?.remove()
        listener = nil
    }
   
    
    // MARK: - Процедура подписки на пользователя
    
    //// ВАЖНО!!!! Перед этим у пользователя через google обязательно нужно создать подколлекцию personalData
    
    // 1. Пользователь нажал на кнопку подписаться у найденного друга
    
    func stepOneForAddFriend(friendId: String) async throws {
        try await DatabaseService.shared.stepOneUserPressedAddFriendButton(friendId: friendId)
    }
    
    // 2. Друг ответил на запрос (подписаться в ответ)
    
    func stepTwoAnswerToRequestPositive(friendId: String) async throws {
        try await DatabaseService.shared.stepTwoForAddFriendPositive(friendId: friendId)
    }
    
    // 3. Друг ответил на запрос (отказал)
    
    func stepTwoAnswerToRequestNegative(friendId: String) async throws {
        try await DatabaseService.shared.stepTwoForAddFriendNegative(friendId: friendId)
    }
    
    // 4. Отписаться от пользователя
    
    func deleteFriend(friendId: String) async throws {
        try await DatabaseService.shared.deleteFriend(friendId: friendId)
    }
    
    
    
    
    
    
    // MARK: -- Прослушиватель коллекции wishlist друга

    func setupWishlistListener(userID: String) {
        guard !isStopListener else { return }
        
        let docRef = Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("wishlist")
        
        wishlistListener = docRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self, !self.isStopListener else { return }
            
            if let error = error {
                print("Ошибка слушателя wishlist: \(error.localizedDescription)")
                return
            }
            
            let presents = snapshot?.documents.compactMap {
                try? $0.data(as: PresentModel.self)
            } ?? []
            
            // Обновляем только если изменилось
            if presents != self.wishlist {
                self.wishlist = presents
            }
        }
    }

    func stopWishlistListener() {
        wishlistListener?.remove()
        wishlistListener = nil
    }
   
   
    
    
    // MARK: -- Прослушиватель, если id друга есть в массиве myFriendsID то statusFriend = true (тогда скрываю кнопку "Подписаться")
    
    func isFriendOrNo(friend: DBUser) {
        
        if let userId = try? AuthenticationManager.shared.getAuthenticatedUser().uid {
            let docRef = Firestore.firestore().collection("users").document(userId).collection("personalData").document(userId)
            
            docRef.addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Ошибка при получении id друзей \(error!)")
                    return
                }

                guard let data = document.data() else {
                    print("Документ пустой")
                    return
                }

                guard let idRequest = data["request_friend"] as? [String] else { return }
                guard let idFriends = data["friends_id"] as? [String] else { return }
                
                for id in idRequest {
                    if friend.userId == id {
                        self.isFriendForRequestArr = true
                    }
                }
                
                for id in idFriends {
                    if friend.userId == id {
                        self.isFriendForFriendstArr = true
                    }
                }
            }
            
            let docRefFriend = Firestore.firestore().collection("users").document(friend.userId).collection("personalData").document(friend.userId)
            
            docRefFriend.addSnapshotListener { snapshot, error in
                guard let document = snapshot else {
                    print("Ошибка при получении id друзей \(error!)")
                    return
                }

                guard let data = document.data() else {
                    print("Документ пустой")
                    return
                }

                guard let idFriends = data["friends_id"] as? [String] else { return }
                
                for id in idFriends {
                    if userId == id {
                        self.isIamFriend = true
                    }
                }
            }
        } else {
            return
        }
    }
    
    func getUrlAsync(id: String) async throws -> URL {
        try await StorageService.shared.downloadURLPresentImageAsync(id: id)
    }
    
    func getUrlImageFriendAsync(id: String) async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: id)
    }
    
    
    
    
    /////////////////////////
    ///
    ///
    
    
    func getAllUsers() async throws {
        self.allUsers = try await DatabaseService.shared.getAllUsers().documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    
    // MARK: - Процесс отображения друзей во вкладке "Подписки" и "Подписчики"
    
    func getMyFriendsID() async throws {
        self.isLoading = true
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["friends_id"] as? [String] else { return }
        self.myFriendsID = id
    }
    
    
    func getSubscriptions() async throws {
        
        try await self.myFriends = DatabaseService.shared.getFriends(myFriendsID: myFriendsID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
        self.isLoading = false
    }
    
    func getMySubscribersID() async throws {
        
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["my_subscribers"] as? [String] else { return }
        self.mySubscribersID = id
    }
    
    func getSubscribers() async throws {
        try await self.mySubscribers = DatabaseService.shared.getFriends(myFriendsID: mySubscribersID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    func getMyRequestID() async throws {
        
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["request_friend"] as? [String] else { return }
        self.myRequestID = id
    }
    
    func getRequest() async throws {
        try await self.myRequest = DatabaseService.shared.getFriends(myFriendsID: myRequestID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //////////////////////
    
    
    
}
