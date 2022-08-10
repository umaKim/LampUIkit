//
//  PopularLampSpotCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

protocol PopularLampSpotCollectionViewCellDelegate:AnyObject {
    func popularLampSpotCollectionViewCellDidTap()
}

class PopularLampSpotCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularLampSpotCollectionViewCell"
    
    weak var delegate: PopularLampSpotCollectionViewCellDelegate?
    
    private let titleLabel:UILabel = {
       let lb = UILabel()
        lb.text = "지금 인기 있는 램프 스팟"
        lb.font = .systemFont(ofSize: 20, weight: .semibold)
        lb.textColor = .black
        return lb
    }()
    
    private lazy var mapImageView: UIImageView = {
       let uv = UIImageView(image: UIImage(systemName: "house"))
        uv.layer.cornerRadius = 16
        uv.backgroundColor = .systemBrown
        uv.isUserInteractionEnabled = true
        return uv
    }()
    
    @objc
    private func tapHandler() {
        delegate?.popularLampSpotCollectionViewCellDidTap()
    }
    
        backgroundColor = .greyshWhite
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, mapImageView])
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.distribution = .fill
        labelStackView.spacing = 17
        
        [labelStackView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
