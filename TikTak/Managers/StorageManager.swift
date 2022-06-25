//
//  StorageManager.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let database = Storage.storage().reference()
    
    private init() {}
    
    // Public
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    public func uploadURL(from url: URL) {
        
    }
    
}
