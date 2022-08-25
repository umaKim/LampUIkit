//
//  HapticManager.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/24.
//
import UIKit
import Foundation

class HapticManager {
    static let shared = HapticManager()
    
    private let generator = UINotificationFeedbackGenerator()
    
    func feedBack(with type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
    func feedBack(with style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
