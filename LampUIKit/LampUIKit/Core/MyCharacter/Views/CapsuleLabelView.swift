//
//  CapsuleLabelView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/29.
//

import UIKit

final class CapsuleLabelView: UIView {
    private let label: UILabel = {
       let lb = UILabel()
        lb.textAlignment = .center
        return lb
    }()
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    private func setupUI() {
        clipsToBounds = true
        
        [label].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        }
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            
            heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
