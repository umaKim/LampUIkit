//
//  LocationRectangleProfileView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import UIKit

final class LocationRectangleProfileView: UIView {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.contentMode = .scaleToFill
        imageView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .robotoBold(15)
        return label
    }()
    private lazy var addrLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkNavy
        label.font = .robotoBold(12)
        return label
    }()
    public func configure(_ location: RecommendedLocation) {
        if let urlString = location.image {
            let url = URL(string: urlString)
            profileImageView.sd_setImage(with: url)
        }
        titleLabel.text = location.title
        addrLabel.text = location.addr
    }
    init() {
        super.init(frame: .zero)
        let labelSv = UIStackView(arrangedSubviews: [titleLabel, addrLabel])
        labelSv.axis = .vertical
        labelSv.distribution = .fill
        labelSv.alignment = .leading
        labelSv.spacing = 8
        let totalSv = UIStackView(arrangedSubviews: [profileImageView, labelSv])
        totalSv.axis = .horizontal
        totalSv.distribution = .fill
        totalSv.alignment = .center
        totalSv.spacing = 16
        [totalSv].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor),
            totalSv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
