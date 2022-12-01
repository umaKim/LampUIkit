//
//  DividerView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import UIKit

class DividerView: UIView {
    init(height: CGFloat = 1) {
        super.init(frame: .zero)
        backgroundColor = .systemGray
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
