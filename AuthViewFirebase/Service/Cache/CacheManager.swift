//
//  CacheManager.swift
//  Wishlist
//
//  Created by Ованес Захарян on 27.12.2023.
//

import Foundation
import SwiftUI

class CacheManager {
    
    static let instanse = CacheManager()
    private init() { }
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100    // 100 Mb
        
        return cache
    }()
    
    
    func add(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Добавлено в кэш")
    }
    
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
        print("Удалено из кэша")
    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
    
    
}
