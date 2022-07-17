//
//  TikTakTests.swift
//  TikTakTests
//
//  Created by Andrey Khakimov on 17.07.2022.
//

import XCTest
@testable import TikTak

class TikTakTests: XCTestCase {
    
    func testPostChildPath() {
        let id = UUID().uuidString
        let user = User(
            username: "Bob Brown",
            profilePictureURL: nil,
            identifier: "123"
        )
        let post = PostModel(identifier: id, user: user)
        XCTAssertEqual(post.videoChildPath, "videos/bob brown/")
    }
    
}
