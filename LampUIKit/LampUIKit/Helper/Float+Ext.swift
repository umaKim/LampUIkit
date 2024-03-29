//
//  Float.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/26.
//

import Foundation

extension Float {
    var zoomLevel: Float {
        return (20000 - self * 1000) - 3500
    }
}
