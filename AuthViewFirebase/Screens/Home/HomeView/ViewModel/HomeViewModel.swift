//
//  HomeViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

//import Combine
import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

final class HomeViewModel: ObservableObject {
    @Published var lists: [ListModel] = [
    ListModel(id: "1", name: "День рождения"),
    ListModel(id: "2", name: "Новый Год"),
    ListModel(id: "3", name: "8 марта")
    ]
    
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
    

 
    
    
}
