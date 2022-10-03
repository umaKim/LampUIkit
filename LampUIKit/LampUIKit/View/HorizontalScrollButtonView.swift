//
//  HorizontalScrollButtonView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/04.
//

import UIKit

class HorizontalScrollButtonView: BaseScrollView<[UIButton]> {
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    override func configure() {
        super.configure()

        isPagingEnabled = false
        showsHorizontalScrollIndicator = false
    }

    override func bind(_ model: [UIButton]) {
        super.bind(model)

        setImages()
    }

    private func setImages() {
        guard let buttons = model else {return }
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 6
        
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
