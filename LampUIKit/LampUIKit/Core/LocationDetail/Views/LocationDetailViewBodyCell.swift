//
//  LocationDetailViewBodyCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import UIKit

class LocationDetailViewBodyCell: UICollectionViewCell {
    static let identifier = "LocationDetailViewBodyCell"
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "이 곳의 여행 후기"
        lb.textColor = .darkNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    private lazy var satisfyView: ReviewLabel = {
       let uv = ReviewLabel(title: "만족도", subTitle: "만족")
        return uv
    }()
    
    private lazy var atmosphereView: ReviewLabel = {
       let uv = ReviewLabel(title: "분위기", subTitle: "만족")
        return uv
    }()
    
    private lazy var surroundingView: ReviewLabel = {
       let uv = ReviewLabel(title: "주차 및 주변", subTitle: "만족")
        return uv
    }()
    
    private lazy var foodView: ReviewLabel = {
       let uv = ReviewLabel(title: "먹거리", subTitle: "만족")
        return uv
    }()
    
    private let dividerView = DividerView()
    
    public func configure() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        let verticalSv = UIStackView(arrangedSubviews: [satisfyView, atmosphereView, surroundingView, foodView])
        verticalSv.axis = .vertical
        verticalSv.alignment = .leading
        verticalSv.distribution = .fillEqually
        verticalSv.spacing = 21
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, verticalSv])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.distribution = .fillProportionally
        sv.spacing = 18
        
        [sv,dividerView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            sv.topAnchor.constraint(equalTo: topAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReviewLabel: UIView {
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        lb.textColor = .midNavy
        return lb
    }()
    
    private let subTitleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .systemFont(ofSize: 15, weight: .semibold)
        lb.textColor = .black
        return lb
    }()
    
    init(title: String, subTitle: String, spacing: CGFloat = 16) {
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        super.init(frame: .zero)
        
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
