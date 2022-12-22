//
//  MyReviewCustomTitleView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/04.
//

import UIKit

final class MyReviewCustomTitleView: UIView {
    private lazy var titleLabel: UILabel = UILabel()
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    var textColor: UIColor? {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    var font: UIFont? {
        didSet {
            titleLabel.font = font
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        layer.borderWidth = 1
        layer.cornerRadius = 9
        layer.borderColor = UIColor(red: 217/250, green: 217/250, blue: 217/250, alpha: 1).cgColor
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
