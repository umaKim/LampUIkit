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
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color]
    }

    func setLargeTitleColor(_ color: UIColor) {
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color]
    }

    func setAllTitleColor(_ color: UIColor) {
        setTitleForgroundTitleColor(color)
        setLargeTitleColor(color)
    }
}
