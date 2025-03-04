//
//  HomeViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

//import Combine
import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

final class HomeViewModel: ObservableObject {
    @Published var myFriends: [DBUser] = []
    @Published var myFriendsID: [String] = [" "]
    @Published var isLoading = false

    
    @Published var uiImage = UIImage(named: "list_image")!
    @Published var url: URL?
    
    @Published var lists: [ListModel] = [] // будет содержать все списки пользователя
    
    @Published var wishlist: [PresentModel] = [] // будет содержать все подарки пользователя
    
    var currentUser = Auth.auth().currentUser
    @Published var isStopListener = false
    @Published private(set) var dbUser: DBUser? = nil
    
    private var listener: ListenerRegistration?
    
    
    init() {
        setupListener()
    }
    
    deinit {
        stopListener()
    }
    
    // MARK: -- Получаю список друзей для календаря
    
    func getUrlUserImage(userId: String) async throws -> URL {
        try await StorageService.shared.downloadURLUserImageAsync(id: userId)
    }
    
    func getMyFriendsID() async throws {
        self.isLoading = true
        let document = try await DatabaseService.shared.getMyDocument()
        
        guard let data = document.data() else { return }
        
        guard let id = data["friends_id"] as? [String] else { return }
        
        DispatchQueue.main.async {
            self.myFriendsID = id
        }
        
    }
    
    func getSubscriptions() async throws {
        
        let friends = try await DatabaseService.shared.getFriends(myFriendsID: myFriendsID).documents.compactMap {
            try? $0.data(as: DBUser.self)
        }
        
        DispatchQueue.main.async {
            self.myFriends = friends
            self.isLoading = false
        }
    }
    
    // MARK: -- --------------------------------------------------------------------------------------------------------
    
    func setupListener() {
        
        guard let uid = currentUser?.uid, !uid.isEmpty else {
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

    // MARK: -- Прослушиватель обновлений коллекции Wishlist. (пишет все данные в переменную wishlist)
    
    func fetchWishlist() {
        
        if let user = AuthService.shared.currentUser {
            let docRef = Firestore.firestore().collection("users").document(user.uid).collection("wishlist")
           
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
    
    func fetchOtherWishlist(list: ListModel) {
        
        if let user = AuthService.shared.currentUser {
            let docRef = Firestore.firestore().collection("users").document(user.uid).collection("list").document(list.id).collection("otherWishlist")
           
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
    
  
    
    
    
    
    // MARK: -- Удаляю подарок из коллекции "Wishlist"
    
    func removingPresentFromWishlist(_ namePresent: String) {
        let docRef = Firestore.firestore().collection("User").document(currentUser?.email ?? "").collection("Wishlist").document(namePresent)
        
        docRef.delete() { error in
            if let error = error {
                print(error)
            } else {
                print("Подарок удален успешно")
            }
        }
    }
    
    
    // MARK: ---------------------- Работа со списками ----------------------
    
    
    
    //MARK: -- Добавляю новый список в коллекцию "List"
    
    
    func setList(newList: ListModel) {
        let image = resizeImage(image: uiImage, targetSize: CGSizeMake(472.0, 709.0))
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        DatabaseService.shared.setList(list: newList, image: imageData) { result in
            switch result {
            case .success(let list):
                print(list.name)
            case .failure(let error):
                print("Ошибка при отправке данных на сервер \(error.localizedDescription)")
            }
        }
    }
    

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        ImageLoader.shared.resizeImage(image: image, targetSize: targetSize)
   }
    
    
    // MARK: -- Прослушиватель обновлений коллекции list. (пишет все данные в переменную list)
    
    func fetchList() {
        
        if let user = AuthService.shared.currentUser {
            let docRef = Firestore.firestore().collection("users").document(user.uid).collection("list")
           
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
    
    
    
    //MARK: -- Добавляю новый подарок в коллекцию "otherWishlist"
    
    
    func setPresentOtherWishlist(list: ListModel, newPresent: PresentModel) {
        let image = resizeImage(image: uiImage, targetSize: CGSizeMake(472.0, 709.0))
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        DatabaseService.shared.setOtherWishlist(list: list, present: newPresent, image: imageData) { result in
            switch result {
            case .success(let list):
                print(list.name)
            case .failure(let error):
                print("Ошибка при отправке данных на сервер \(error.localizedDescription)")
            }
        }
    }
    
    
    // MARK: -- Удаление списка
    
    func removingList(list: ListModel) {
        guard let user = currentUser else { return }
        
        let docRef = Firestore.firestore().collection("users").document(user.uid).collection("list").document(list.id)
        
        docRef.delete() { error in
            if let error = error {
                print(error)
            } else {
                print("Лист \(list.name) удален успешно")
            }
        }
    }
    
    // MARK: -- Удаление всех фотографий подарков из удаляемого списка
    
    func deletePresentImage() {
        
        var listArrayAllPresenID: [String] = []
        
        listArrayAllPresenID = wishlist.map { $0.id }
//        print("Вот список всех подарков: ------------------------- \(wishlist)")
//        print("Вот список всех id: -------------------------- \(listArrayAllPresenID)")
        
        for id in listArrayAllPresenID {
            StorageService.shared.deletePresentImage(id: id) { result in
                switch result {
                case .success(_):
                    print("Изображение подарка удалено из хранилища!")
                case .failure(_):
                    print("Возникла ошибка при удалении изображения из хранилища")
                }
            }
        }
    }
    
    func removingListImage(list: ListModel) {
        StorageService.shared.deleteListImage(id: list.id) { result in
            switch result {
            case .success(_):
                print("Изображение листа \(list.id) удалено из хранилища!")
            case .failure(_):
                print("Возникла ошибка при удалении изображения из хранилища")
            }
        }
    }
    
}
