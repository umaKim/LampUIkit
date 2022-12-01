//
//  LocationDescriptionView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/16.
//
import SkeletonView
import UIKit

class LocationDescriptionView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightNavy
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 2
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return label
    }()
    init(_ title: String, description: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title.localized
        descriptionLabel.text = description.htmlToAttributedString?.string
        setupUI()
    }
    public func configure(_ title: String, _ description: String) {
        titleLabel.text = title.localized
        if description == "" {
            descriptionLabel.text = "TBA"
        } else {
            descriptionLabel.text = description.htmlToAttributedString?.string
        }
    }
    public func showSkeleton() {
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        titleLabel.isSkeletonable = true
        titleLabel.showAnimatedGradientSkeleton(
            usingGradient: .init(colors: [.lightGray, .gray]),
            animation: skeletonAnimation,
            transition: .none
        )
        descriptionLabel.isSkeletonable = true
        descriptionLabel.showAnimatedGradientSkeleton(
            usingGradient: .init(colors: [.lightGray, .gray]),
            animation: skeletonAnimation,
            transition: .none
        )
    }
    public func hideSkeleton() {
        titleLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 16
        [stackView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
