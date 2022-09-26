//
//  AnswerButton.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import UIKit

class AnswerButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .darkNavy
        layer.borderWidth = 2
        layer.borderColor = UIColor.midNavy.cgColor
        layer.cornerRadius = 5
        widthAnchor.constraint(equalToConstant: 280).isActive = true
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        titleLabel?.numberOfLines = 0; // Dynamic number of lines
        titleLabel?.lineBreakMode = .byWordWrapping;
        titleLabel?.textAlignment = .center
        titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        
        clipsToBounds = true
        
        titleEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
