//
//  Sequence+Ext.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/09.
//

import Foundation

extension Sequence where Iterator.Element == NSAttributedString {
    func joined(with separator: NSAttributedString) -> NSAttributedString {
        return self.reduce(NSMutableAttributedString()) {
            reducer, element in
            if reducer.length > 0 {
                reducer.append(separator)
            }
            reducer.append(element)
            return reducer
        }
    }

    func joined(with separator: String = "") -> NSAttributedString {
        return self.joined(with: NSAttributedString(string: separator))
    }
}
