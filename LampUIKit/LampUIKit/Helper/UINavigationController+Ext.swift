//
//  UINavigationController+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//
import UIKit
import Foundation

extension UINavigationController {
    func setTitleForgroundTitleColor(_ color: UIColor) {
        let attributedKey = NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue)
        self.navigationBar.titleTextAttributes = [attributedKey: color]
    }

    func setLargeTitleColor(_ color: UIColor) {
        let attributedKey = NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue)
        self.navigationBar.largeTitleTextAttributes = [attributedKey: color]
    }

    func setAllTitleColor(_ color: UIColor) {
        setTitleForgroundTitleColor(color)
        setLargeTitleColor(color)
    }
}
