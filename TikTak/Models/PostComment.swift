//
//  PostComment.swift
//  TikTak
//
//  Created by Andrey Khakimov on 27.06.2022.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date
    
    static func mockComments() -> [PostComment] {
        let user = User(username: "George", profilePictureURL: nil, identifier: UUID().uuidString)
        return [
            PostComment(text: "WTF??", user: user, date: Date()),
            PostComment(text: "NO WAAY??", user: user, date: Date())
        ]
    }
}
