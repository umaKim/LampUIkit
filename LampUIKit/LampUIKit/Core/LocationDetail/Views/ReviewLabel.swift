//
//  ReviewLabel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//

import UIKit

class ReviewLabel: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .lightNavy
        label.numberOfLines = 2
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return label
    }()
    private lazy var subTitleLabel = RoundedLabelView("")
    public func setSubtitle(_ text: String) {
        self.subTitleLabel.setText(text.localized)
    }
    init(
        title: String,
        subTitle: String,
        spacing: CGFloat = 16,
        titleTextColor: UIColor = .lightNavy,
        setRoundDesign: Bool = true
    ) {
        self.titleLabel.text = title.localized
        self.titleLabel.textColor = titleTextColor
        super.init(frame: .zero)
        self.subTitleLabel.setText(subTitle.localized)
        self.subTitleLabel.setRound(setRoundDesign)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = spacing
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
