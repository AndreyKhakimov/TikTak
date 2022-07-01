//
//  ExploreBannerViewModel.swift
//  TikTak
//
//  Created by Andrey Khakimov on 01.07.2022.
//

import Foundation
import UIKit

struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
