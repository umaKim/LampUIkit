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
        let horizontalStackView = UIStackView(arrangedSubviews: buttons)
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 6
        addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
