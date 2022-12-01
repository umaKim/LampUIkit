//
//  SquareButton.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import UIKit

class SquareButton: UIButton {
    init(_ length: CGFloat) {
        super.init(frame: .zero)
        heightAnchor.constraint(equalToConstant: length).isActive = true
        widthAnchor.constraint(equalToConstant: length).isActive = true
        backgroundColor = .white
    }
    convenience init(
        _ image: UIImage?,
        _ length: CGFloat = 40
    ) {
        self.init(length)
        setImage(image, for: .normal)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
