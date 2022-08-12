//
//  CircleButton.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import UIKit

class CircleButton: UIButton {
    init(_ length: CGFloat, _ color: UIColor) {
        super.init(frame: .zero)
        
        let length: CGFloat = 60
        layer.cornerRadius = length / 2
        heightAnchor.constraint(equalToConstant: length).isActive = true
        widthAnchor.constraint(equalToConstant: length).isActive = true
        backgroundColor = color
    }
    
    convenience init(_ image: UIImage?, _ color: UIColor, _ length: CGFloat = 60) {
        self.init(length, color)
        setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
