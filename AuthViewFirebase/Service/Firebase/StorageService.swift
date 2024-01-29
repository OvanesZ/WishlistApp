//
//  StorageService.swift
//  AuthViewFirebase
//
//  Created by Ованес Захарян on 17.09.2023.
//

import Foundation
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    private init() { }
    
    // MARK: - private let
    private let storage = Storage.storage().reference()
    
    // MARK: - private var
    private var userImageRef: StorageReference {
        storage.child("userImage")
    }
    
    private var presentImageRef: StorageReference {
        storage.child("presentImage")
    }
    
    // MARK: - func
    
    
    func uploadAsync(id: String, data: Data) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let returnedMetaData = try await userImageRef.child(id).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    
    
    func upload(id: String, image: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        userImageRef.child(id).putData(image, metadata: metadata) { metadata, error in
            
            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Размер полученного изображения \(metadata.size)"))
        }
    }
    
    func downloadUserImageAsync(id: String) async throws -> Data {
        try await userImageRef.child(id).data(maxSize: 2 * 1024 * 1024)
    }
    
    func downloadUserImage(id: String, completion: @escaping (Result<Data, Error>) -> ()) {
        userImageRef.child(id).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
    
    func downloadURLUserImageAsync(id: String) async throws -> URL {
        try await userImageRef.child(id).downloadURL()
    }
    
    func downloadURLUserImage(id: String, completion: @escaping (Result<URL?, Error>) -> ()) {
        userImageRef.child(id).downloadURL { url, error in
            guard url != nil else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(url))
        }
    }
    
    func uploadPresentImage(id: String, image: Data, completion: @escaping (Result<String, Error>) -> ()) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        presentImageRef.child(id).putData(image, metadata: metadata) { metadata, error in
            
            guard let metadata = metadata else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success("Размер полученного изображения \(metadata.size)"))
        }
    }
    
    func downloadPresentImage(id: String, completion: @escaping (Result<Data, Error>) -> ()) {
        presentImageRef.child(id).getData(maxSize: 3 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
    
    func downloadURLPresentImageAsync(id: String) async throws -> URL {
        try await presentImageRef.child(id).downloadURL()
    }
    
    func downloadURLPresentImage(id: String, completion: @escaping (Result<URL?, Error>) -> ()) {
        presentImageRef.child(id).downloadURL { url, error in
            guard let data = url else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(url))
        }
    }
    
    func deletePresentImage(id: String, completion: @escaping (Result<Data, Error>) -> ()) {
        presentImageRef.child(id).delete { error in
            if error != nil {
                print("Ошибка при удалении изображения подарка!")
            } else {
                print("Изображение удалено успешно!")
            }
        }
    }
    
    
    
}
