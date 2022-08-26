//
//  Float.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/26.
//

import Foundation

extension Float {
    var zoomLevel: Float {
        get {
            return (20000 - self * 1000) - 2000
        }
    }
}
