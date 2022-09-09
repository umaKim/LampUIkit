//
//  ReviewLabel.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//

import UIKit

class ReviewLabel: UIView {
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .bold)
        lb.textColor = .lightNavy
        lb.numberOfLines = 2
        lb.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return lb
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
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = spacing
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(sv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
