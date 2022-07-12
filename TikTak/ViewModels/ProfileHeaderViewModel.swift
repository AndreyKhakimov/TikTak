//
//  ProfileHeaderViewModel.swift
//  TikTak
//
//  Created by Andrey Khakimov on 12.07.2022.
//

import Foundation

struct ProfileHeaderViewModel {
    let avatarImageURL: URL?
    let followerCount: Int
    let followingCount: Int
    let isFollowing: Bool?
}
