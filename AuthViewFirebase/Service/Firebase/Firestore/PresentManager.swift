//
//  WishlistManager.swift
//  Wishlist
//
//  Created by Ованес Захарян on 30.11.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
//import SwiftSoup

struct DBPresent: Codable {
    var presentId: String = UUID().uuidString
    let name: String?
    let urlText: String?
    let presentFromUserId: String?
    var isReserved: Bool = false
    let presentDescription: String?
    
    init(presentId: String, name: String?, urlText: String?, presentFromUserId: String?, isReserved: Bool, presentDescription: String?) {
        self.presentId = UUID().uuidString
        self.name = name
        self.urlText = urlText
        self.presentFromUserId = presentFromUserId
        self.isReserved = isReserved
        self.presentDescription = presentDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case presentId = "present_id"
        case name = "name"
        case urlText = "url_text"
        case presentFromUserId = "present_from_user_id"
        case isReserved = "is_reserved"
        case presentDescription = "present_description"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.presentId = try container.decode(String.self, forKey: .presentId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.urlText = try container.decodeIfPresent(String.self, forKey: .urlText)
        self.presentFromUserId = try container.decodeIfPresent(String.self, forKey: .presentFromUserId)
        self.isReserved = try container.decodeIfPresent(Bool.self, forKey: .isReserved) ?? false
        self.presentDescription = try container.decodeIfPresent(String.self, forKey: .presentDescription)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.presentId, forKey: .presentId)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.urlText, forKey: .urlText)
        try container.encodeIfPresent(self.presentFromUserId, forKey: .presentFromUserId)
        try container.encodeIfPresent(self.isReserved, forKey: .isReserved)
        try container.encodeIfPresent(self.presentDescription, forKey: .presentDescription)
    }
    
}



final class PresentManager {
    
    static let shared = PresentManager()
    private init() { }
    
    private let presentCollection = Firestore.firestore().collection("wishlist")
    
    private func presentDocument(presentId: String) -> DocumentReference {
        presentCollection.document(presentId)
    }
    
    
    func createNewPresent(userId: String, present: DBPresent) async throws {
        try Firestore.firestore().collection("users").document(userId).collection("wishlist").document(present.presentId).setData(from: present, merge: false)
    }
    
    func getPresent(presentId: String) async throws -> DBPresent {
        try await presentDocument(presentId: presentId).getDocument(as: DBPresent.self)
    }
    
//    func createNewList(userId: String, list: DBList) async throws {
//        try Firestore.firestore().collection("users").document(userId).collection("list").document(list.listId).setData(from: list, merge: false)
//    }
    
    
    
    // Функция для парсинга данных со страницы Ozon.ru
//    func parseOzonProductData(from url: URL, presentFromUserID: String, ownerId: String, completion: @escaping (Result<PresentModel, Error>) -> Void) {
//        let session = URLSession.shared
//        let task = session.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(.failure(error ?? NSError(domain: "ParsingError", code: 0, userInfo: nil)))
//                return
//            }
//            
//            do {
//                // Преобразуем данные в строку
//                let htmlContent = String(data: data, encoding: .utf8)
//                
//                // Создаем объект Document для анализа HTML
//                let document = try SwiftSoup.parse(htmlContent ?? "")
//                
//                // Извлекаем название товара
//                let productNameElement = try document.select("h1.n7f").first()
//                let productName = try productNameElement?.text() ?? "Название не найдено"
//                
//                // Извлекаем описание товара
//                let productDescriptionElement = try document.select("div.a6k").first()
//                var productDescription = try productDescriptionElement?.text() ?? "Описание не найдено"
//                
//                // Если основное описание отсутствует, попробуем найти характеристики
//                if productDescription == "Описание не найдено" {
//                    let featuresElement = try document.select("div.g-i-Tw-yI.g-i-v3HrZs.g-i-FQ05tS.g-i-K4X8bA").first()
//                    let featuresText = try featuresElement?.text() ?? ""
//                    if !featuresText.isEmpty {
//                        productDescription = featuresText
//                    }
//                }
//                
//                // Извлекаем ссылку на изображение
//                let productImageElement = try document.select("img.e9b").first()
//                let productImageUrl = try productImageElement?.attr("src") ?? ""
//                
//                // Создаем объект PresentModel
//                var present = PresentModel(
//                    name: productName,
//                    urlText: url.absoluteString,
//                    presentFromUserID: presentFromUserID,
//                    ownerId: ownerId,
//                    whoReserved: ""
//                )
//                
//                // Устанавливаем описание, если оно есть
//                present.presentDescription = productDescription
//                
//                // Возвращаем результат
//                DispatchQueue.main.async {
//                    completion(.success(present))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        
//        task.resume()
//    }

    

    
    
    
    
    
    
    
    
    
    
    
}


//struct DBList: Codable {
//    var listId: String = UUID().uuidString
//    let name: String?
//    
//    init(listId: String, name: String?) {
//        self.listId = UUID().uuidString
//        self.name = name
//    }
//    
//    enum CodingKeys: String, CodingKey {
//        case listId = "list_id"
//        case name = "name"
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.listId = try container.decode(String.self, forKey: .listId)
//        self.name = try container.decodeIfPresent(String.self, forKey: .name)
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.listId, forKey: .listId)
//        try container.encodeIfPresent(self.name, forKey: .name)
//    }
//}
