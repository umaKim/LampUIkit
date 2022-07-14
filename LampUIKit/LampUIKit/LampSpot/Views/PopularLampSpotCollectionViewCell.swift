//
//  PopularLampSpotCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

class PopularLampSpotCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularLampSpotCollectionViewCell"
    
    private let titleLabel:UILabel = {
       let lb = UILabel()
        lb.text = "지금 인기 있는 램프 스팟"
        lb.font = .systemFont(ofSize: 20, weight: .semibold)
        return lb
    }()
    
    private lazy var mapImageView: UIImageView = {
       let uv = UIImageView(image: UIImage(systemName: "house"))
        uv.layer.cornerRadius = 16
        uv.backgroundColor = .systemBrown
        return uv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brown
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
        labelStackView.spacing = 6
        
        [labelStackView, mapImageView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            mapImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mapImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapImageView.topAnchor.constraint(equalTo: labelStackView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
