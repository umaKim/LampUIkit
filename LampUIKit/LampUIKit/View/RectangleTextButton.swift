//
//  RectangleTextButton.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import UIKit

class RectangleTextButton: UIButton {
    init(
        _ title: String,
        background: UIColor,
        textColor: UIColor = .black,
        fontSize: CGFloat
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = background
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    override var isHighlighted: Bool {
        didSet {
            // If you have images in your button, add them here same as the code below
            (self.isHighlighted && self.titleLabel != nil) ? (self.titleLabel!.alpha = 0.2) : (self.titleLabel!.alpha = 1.0)
        }
    }
    
    public func update(
        _ title: String,
        background: UIColor,
        textColor: UIColor = .black
    ) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
