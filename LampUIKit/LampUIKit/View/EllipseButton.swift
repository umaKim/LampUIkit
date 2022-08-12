//
//  EllipseButton.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/12.
//

import UIKit

class EllipseButton: UIButton {
    init(_ length: CGFloat, _ height: CGFloat) {
        super.init(frame: .zero)
        
        layer.cornerRadius = height / 2
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: length).isActive = true
        
        backgroundColor = .darkNavy
    }
    
    convenience init(image: UIImage?, length: CGFloat = 80, height: CGFloat = 30) {
        self.init(length, height)
        
        setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
