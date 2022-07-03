//
//  ExploreUserViewModel.swift
//  TikTak
//
//  Created by Andrey Khakimov on 01.07.2022.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
