//
//  UIFont+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//
import UIKit
import Foundation

extension UIFont {
    static func robotoLight(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Light", size: size)
    }
    static func robotoBold(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Bold", size: size)
    }
    static func robotoMedium(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Medium", size: size)
    }
    static func robotoRegular(_ size: CGFloat) -> UIFont? {
        UIFont(name: "Roboto-Rgular", size: size)
    }
}
