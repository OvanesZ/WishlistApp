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
    
    private let currentUser = Auth.auth().currentUser
    
    //MARK: -- Добавляю новый подарок в коллекцию "Wishlist"
    
    
    func setPresent(newPresent: PresentModel) {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.75) else { return }
        
        DatabaseService.shared.setPresent(present: newPresent, image: imageData) { result in
            switch result {
            case .success(let present):
                print(present.name)
            case .failure(let error):
                print("Ошибка при отправке данных на сервер \(error.localizedDescription)")
            }
        }
    }
    
    // Новый асинхронный запрос для создания подарка. Пока не использую
    
    func setPresentInFirestore(newPresent: DBPresent) async throws {
        try await PresentManager.shared.createNewPresent(userId: currentUser!.uid, present: newPresent)
    }
    
    
    func getPresentImage() {
        StorageService.shared.downloadPresentImage(id: present.id) { result in
            switch result {
            case .success(let data):
                if let img = UIImage(data: data) {
                    self.uiImage = img
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getUrlPresentImage(presentId: String) {
        self.isLoadUrl = true
        StorageService.shared.downloadURLPresentImage(id: presentId) { result in
            switch result {
            case .success(let url):
                self.isLoadUrl = false
                if let url = url {
                    self.url = url
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        let docRef = Firestore.firestore().collection("users").document(friendID).collection("wishlist").document(present.id)
        
        docRef.updateData([
            "isReserved": true
        ]) { error in
            if let error = error {
                print("Ошибка при обновлении документа \(error)")
            } else {
                print("Документ обновлен успешно")
            }
        }
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
    
    
    
    
}
