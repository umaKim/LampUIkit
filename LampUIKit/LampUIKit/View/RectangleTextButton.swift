//
//  RectangleTextButton.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import UIKit

class RectangleTextButton: UIButton {
    init(_ title: String, background: UIColor, textColor: UIColor = .black) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = background
        self.layer.cornerRadius = 5
        
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
        heightAnchor.constraint(equalToConstant: 51).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
