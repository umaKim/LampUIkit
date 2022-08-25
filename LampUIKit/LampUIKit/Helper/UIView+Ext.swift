//
//  UIView+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//
import UIKit
import Foundation

extension UIView {
    func configureShadow( _ shadowOpacity: Float = 0.2, _ shadowRadius: CGFloat = 7) {
        layer.masksToBounds = false
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = shadowRadius
    }
}
