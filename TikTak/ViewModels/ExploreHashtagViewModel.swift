//
//  ExploreHashtagViewModel.swift
//  TikTak
//
//  Created by Andrey Khakimov on 01.07.2022.
//

import Foundation
import UIKit

struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int
    let handler: (() -> Void)
}
