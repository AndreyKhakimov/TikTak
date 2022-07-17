//
//  ExploreResponse.swift
//  TikTak
//
//  Created by Andrey Khakimov on 17.07.2022.
//

import Foundation

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
