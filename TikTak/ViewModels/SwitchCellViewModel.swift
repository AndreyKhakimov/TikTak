//
//  SwitchCellViewModel.swift
//  TikTak
//
//  Created by Andrey Khakimov on 15.07.2022.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
