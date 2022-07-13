//
//  PostModel.swift
//  TikTak
//
//  Created by Andrey Khakimov on 25.06.2022.
//

import Foundation

struct PostModel {
    
    let identifier: String
    let user: User
    var fileName: String = ""
    var caption: String = ""
    
    var isLikedByCurrentUser = false
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "Bob",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                )
            )
            posts.append(post)
        }
        return posts
    }
    
}
