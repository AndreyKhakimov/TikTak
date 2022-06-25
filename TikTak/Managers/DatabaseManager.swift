//
//  DatabaseManager.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    // Public
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
