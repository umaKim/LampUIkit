//
//  MyMapCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

class MyMapCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyMapCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "MY LAMP"
        lb.font = .systemFont(ofSize: 28, weight: .bold)
        return lb
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "대한민국 지도에 나만의 흔적 남기기"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        return lb
    }()
    
    private lazy var mapImageView: UIImageView = {
       let uv = UIImageView(image: UIImage(systemName: "house"))
        uv.layer.cornerRadius = 16
        uv.backgroundColor = .systemRed
        return uv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
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
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
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
