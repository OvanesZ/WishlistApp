//
//  PresentViewModel.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 28.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage

class PresentModelViewModel: ObservableObject {
    
    let present: PresentModel
    
    @Published var uiImage = UIImage(named: "logo_wishlist")!
    @Published var isHiddenReservButton: Bool
    @Published var url: URL?
    @Published var isLoadUrl = false
    
    init(present: PresentModel) {
        self.present = present
        self.isHiddenReservButton = present.isReserved
    }
    
    let currentUser = Auth.auth().currentUser
    
    //MARK: -- Добавляю новый подарок в коллекцию "Wishlist"
    
    
    func setPresent(newPresent: PresentModel) {
        let image = resizeImage(image: uiImage, targetSize: CGSizeMake(472.0, 709.0))
        print("Разрешение загруженного изображения = \(image.size)")
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        DatabaseService.shared.setPresent(present: newPresent, image: imageData) { result in
            switch result {
            case .success(let present):
                print(present.name)
            case .failure(let error):
                print("Ошибка при отправке данных на сервер \(error.localizedDescription)")
            }
        }
    }
    
    func setPresentInFirestore(newPresent: DBPresent) async throws {
        try await PresentManager.shared.createNewPresent(userId: currentUser!.uid, present: newPresent)
    }
    
    func getUrlPresentImage(presentId: String) async throws -> URL {
        try await StorageService.shared.downloadURLPresentImageAsync(id: presentId)
    }
    
    func deletePresentImage() {
        StorageService.shared.deletePresentImage(id: present.id) { result in
            switch result {
            case .success(_):
                print("Изображение подарка удалено из хранилища!")
            case .failure(_):
                print("Возникла ошибка при удалении изображения из хранилища")
            }
        }
    }
    
    //MARK: -- Резерв подарка без информации о друге 
    
    func reservingPresentForUserID(_ present: PresentModel, _ friendID: String) {
        guard let user = currentUser else { return }
        let docRef = Firestore.firestore().collection("users").document(friendID).collection("wishlist").document(present.id)
        
        docRef.updateData([
            "isReserved": true,
            "whoReserved": user.uid
        ]) { error in
            if let error = error {
                print("Ошибка при обновлении документа \(error)")
            } else {
                print("Документ обновлен успешно")
            }
        }
    }
    
    //MARK: -- Отмена резерва подарка без информации о друге
    func unReservingPresentForUserID(_ present: PresentModel, _ friendID: String) {
      
        let docRef = Firestore.firestore().collection("users").document(friendID).collection("wishlist").document(present.id)
        
        docRef.updateData([
            "isReserved": false,
            "whoReserved": ""
        ]) { error in
            if let error = error {
                print("Ошибка при обновлении документа \(error)")
            } else {
                print("Документ обновлен успешно")
            }
        }
    }
    
    // MARK: - При отмене резерва подарка удаляю его из коллекции presentsForFriend
    
    func deletePresentFriendPresentList(present: PresentModel) async throws {
        try await DatabaseService.shared.deletePresentFriendPresentList(present: present)
    }
    
    // MARK: -- В момент резерва подарка создаю подколлекцию с информацией о id подарка и друга
    
    func setFriendPresentList(present: PresentModel) async throws {
        try await DatabaseService.shared.setFriendPresentList(present: present)
    }
    
    // MARK: -- Удаляю подарок из коллекции "Wishlist"
    
    func removingPresentFromWishlist(_ idPresent: String) {
        guard let user = currentUser else { return }
        
        let docRef = Firestore.firestore().collection("users").document(user.uid).collection("wishlist").document(idPresent)
        
        docRef.delete() { error in
            if let error = error {
                print(error)
            } else {
                print("Подарок удален успешно")
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        ImageLoader.shared.resizeImage(image: image, targetSize: targetSize)
   }
    
}





