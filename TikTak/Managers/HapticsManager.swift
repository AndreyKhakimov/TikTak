//
//  HapticsManager.swift
//  TikTak
//
//  Created by Andrey Khakimov on 24.06.2022.
//

import Foundation
import UIKit

final class HapticsManager {
    public static let shared = HapticsManager()
    
    private init() {}
    
    // Public
    
    public func vibrateForSeletion() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
