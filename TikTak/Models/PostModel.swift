//
//  PostModel.swift
//  TikTak
//
//  Created by Andrey Khakimov on 25.06.2022.
//

import Foundation

struct PostModel {
    let identifier: String
    
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
