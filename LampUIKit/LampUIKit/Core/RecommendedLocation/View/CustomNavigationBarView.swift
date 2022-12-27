//
//  CustomNavigationBarView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/28.
//

import UIKit

enum CustomNavigationBarViewAction: Actionable { }

final class CustomNavigationBarView: BaseView<CustomNavigationBarViewAction> {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .midNavy
        label.numberOfLines = 2
        return label
    }()
    private lazy var buttonSv: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    override init() {
        super.init()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension CustomNavigationBarView {
    public func setRightSideItems(_ buttons: [UIButton]) {
        buttons.forEach { uiView in
            self.buttonSv.addArrangedSubview(uiView)
        }
    }
    public func updateTitle(_ text: String) {
        titleLabel.text = text
    }
}

// MARK: - Set up UI
extension CustomNavigationBarView {
    private func setupUI() {
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        addSubviews(titleLabel, buttonSv)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            titleLabel.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 16),
            buttonSv.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            buttonSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
