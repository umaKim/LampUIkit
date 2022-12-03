//
//  MyPageTableViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/26.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .midNavy
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    private func setupUI() {
        backgroundColor = .greyshWhite
        [titleLabel].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with title: String) {
        self.titleLabel.text = title.localized
    }
}
