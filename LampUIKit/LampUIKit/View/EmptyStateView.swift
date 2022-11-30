//
//  EmptyStateView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/02.
//

import UIKit

class EmptyStateView: UIView {
    private let messageLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    private let logoImageView   = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    private func configure() {
        [logoImageView, messageLabel].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        logoImageView.image         = UIImage(named: "sadRacoon")
        logoImageView.backgroundColor = .greyshWhite
        messageLabel.numberOfLines  = 3
        messageLabel.textColor      = .secondarySystemFill
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.widthAnchor.constraint(equalToConstant: 300),
            messageLabel.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor)
        ])
    }
}
