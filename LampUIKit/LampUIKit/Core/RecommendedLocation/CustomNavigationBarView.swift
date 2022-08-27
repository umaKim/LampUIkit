//
//  CustomNavigationBarView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/28.
//

import UIKit

class CustomNavigationBarView: BaseWhiteView {
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .robotoBold(20)
        lb.textColor = .midNavy
        return lb
    }()
    
    private lazy var buttonSv: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 16
        return sv
    }()
    
    override init() {
        super.init()
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        [titleLabel, buttonSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -6),
            
            buttonSv.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            buttonSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    public func setRightSideItems(_ buttons: [UIButton]) {
        buttons.forEach { uv in
            self.buttonSv.addArrangedSubview(uv)
        }
    }
    
    public func updateTitle(_ text: String) {
        titleLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
