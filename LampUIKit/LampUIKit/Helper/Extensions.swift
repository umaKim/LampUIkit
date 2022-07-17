//
//  Extensions.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/15.
//

import UIKit

extension UIScreen {
    var width: CGFloat {
        return bounds.width
    }
    
    var height: CGFloat {
        return bounds.height
    }
}

extension UIColor {
    static let midNavy = UIColor(red: 92/255, green: 92/255, blue: 141/255, alpha: 1)
    static let lightGrey = UIColor(red: 228/255, green: 228/255, blue: 232/255, alpha: 1)
    static let greyshWhite = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    static let darkNavy = UIColor(red: 38/255, green: 38/255, blue: 92/255, alpha: 1)
    static let lightNavy = UIColor(red: 112/255, green: 112/255, blue: 255/255, alpha: 1)
}
