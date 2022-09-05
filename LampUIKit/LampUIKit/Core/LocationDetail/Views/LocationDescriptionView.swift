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
        let lb = UILabel()
        lb.textColor = .midNavy
        lb.font = .robotoMedium(14)
        lb.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lb.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return lb
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        lb.textAlignment = .left
        lb.font = .robotoMedium(14)
        return lb
    }()
    
    init(_ title: String, description: String) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        descriptionLabel.text = description.htmlToAttributedString?.string
        
        setupUI()
    }
    
    public func configure(_ title: String, _ description: String) {
        titleLabel.text = title
        descriptionLabel.text = description.htmlToAttributedString?.string
    }
    
    public func showSkeleton() {
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        
        titleLabel.isSkeletonable = true
        titleLabel.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]),
                                                animation: skeletonAnimation,
                                                transition: .none)
        descriptionLabel.isSkeletonable = true
        descriptionLabel.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]),
                                                      animation: skeletonAnimation,
                                                      transition: .none)
    }
    
    public func hideSkeleton() {
        titleLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .top
        sv.spacing = 16
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
