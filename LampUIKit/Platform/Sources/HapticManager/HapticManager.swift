//
//  HapticManager.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/24.
//
import UIKit
import Foundation

public class HapticManager {
    public static let shared = HapticManager()
    private let generator = UINotificationFeedbackGenerator()
    public func feedBack(with type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    public func feedBack(with style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
