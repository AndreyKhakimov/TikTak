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
    
    /// Insert a new user
    /// - Parameters:
    ///   - email: user email
    ///   - username: user username
    ///   - completion: Async result callback
    public func insertUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                self?.database.child("users").setValue(
                    [
                        username: [
                            "email": email
                        ]
                    ]
                ) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
            usersDictionary[username] = ["email": email]
            // save new users object
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    /// Get username for a given email
    /// - Parameters:
    ///   - email: Email to query
    ///   - completion: Async result callback
    public func getUsername(for email: String, completion: @escaping (String?) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            for (username, value) in users {
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
            }
        }
    }
    
    /// Insert new post
    /// - Parameters:
    ///   - fileName: File name to insert for
    ///   - caption: Caption to insert for
    ///   - completion: Async result callback
    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        
        database.child("users").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            let newEntry = [
                "name" : fileName,
                "caption" : caption
            ]
            
            if var posts = value["posts"] as? [[String: Any]] {
                posts.append(newEntry)
                value["posts"] = posts
                self?.database.child("users").child(username).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                value["posts"] = [newEntry]
                self?.database.child("users").child(username).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }            }
        }
    }
    
    public func getNotifications(completion: @escaping ([Notification]) -> Void) {
        completion(Notification.mockData())
    }
    
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void) {
        // TODO: Replace with real code
        completion(true)
    }
    
    /// Get posts for a given user
    /// - Parameters:
    ///   - user: User to get posts for
    ///   - completion: Async result callback
    public func getPosts(for user: User, completion: @escaping ([PostModel]) -> Void) {
        
        let path = "users/\(user.username.lowercased())/posts"
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let posts = snapshot.value as? [[String: String]] else {
                completion([])
                return
            }
            let models: [PostModel] = posts.compactMap {
                var model = PostModel(identifier: UUID().uuidString, user: user)
                model.fileName = $0["name"] ?? ""
                model.caption = $0["caption"] ?? ""
                return model
            }
            completion(models)
        }
    }
    
    /// Get relationship status for current and target user
    /// - Parameters:
    ///   - user: Target user to check following status for
    ///   - type: Type to be checked
    ///   - completion: Async result callback
    public func getRelationships(
        for user: User,
        type: UserListViewController.ListType,
        completion: @escaping ([String]) -> Void
    ) {
        
        let path = "users/\(user.username.lowercased())/\(type.rawValue)"
        print("Fetching path: \(path)")
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let usernameCollection = snapshot.value as? [String] else {
                completion([])
                return
            }
            
            completion(usernameCollection)
        }
    }
    
    /// Check if  a relationship is valid
    /// - Parameters:
    ///   - user: Target user to check
    ///   - type: Type to check
    ///   - completion: Async result callback
    public func isValidRelationship(
        for user: User,
        type: UserListViewController.ListType,
        completion: @escaping(Bool) -> Void
    ) {
        guard let currentUserName = UserDefaults.standard.string(forKey: "username")?.lowercased() else { return }
        
        let path = "users/\(user.username.lowercased())/\(type.rawValue)"
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let usernameCollection = snapshot.value as? [String] else {
                completion(false)
                return
            }
            completion(usernameCollection.contains(currentUserName))
        }
    }
    
    /// Update follow status for user
    /// - Parameters:
    ///   - user: Target user
    ///   - follow: Follow or unfollow status
    ///   - completion: Async result callback
    public func updateRelationship(
        for user: User,
        follow: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserName = UserDefaults.standard.string(forKey: "username")?.lowercased() else { return }
        
        if follow {
            // follow
            
            // Insert in current user's following
            let path = "users/\(currentUserName)/following"
            database.child(path).observeSingleEvent(of: .value) { snapshot in
                let usernameToInsert = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                } else {
                    self.database.child(path).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            // Insert in target user's followers
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { snapshot in
                let usernameToInsert = currentUserName.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                } else {
                    self.database.child(path2).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        } else {
            // unfollow
            // Remove in current user's following
            let path = "users/\(currentUserName)/following"
            database.child(path).observeSingleEvent(of: .value) { snapshot in
                let usernameToRemove = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: { $0 == usernameToRemove})
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            // Remove in target user's followers
            let path2 = "users/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { snapshot in
                let usernameToRemove = currentUserName.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: { $0 == usernameToRemove})
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            
        }
    }
    
}
