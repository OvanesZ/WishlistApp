//
//  HomeViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import Combine
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

final class HomeViewModel: ObservableObject {
    
    
    @Published var wishlist: [PresentModel] = [] // будет содержать все подарки пользователя
    var currentUser = Auth.auth().currentUser
    
    
//    init() {
//        fetchWishlist()
//    }
    
    
    
    

    // MARK: -- Прослушиватель обновлений коллекции Wishlist. (пишет все данные в переменную wishlist)
    
    func fetchWishlist() {
        
        if let user = AuthService.shared.currentUser {
            let docRef = Firestore.firestore().collection("users").document(user.uid).collection("wishlist")
            docRef.addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.wishlist = snapshot?.documents.compactMap {
                    try? $0.data(as: PresentModel.self)
                } ?? []
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
