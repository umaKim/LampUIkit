//
//  MyMapCollectionViewCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import UIKit

protocol MyMapCollectionViewCellDelegate: AnyObject {
    func didSelectMyLampImage()
}

class MyMapCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyMapCollectionViewCell"
    
    weak var delegate: MyMapCollectionViewCellDelegate?
    
    private lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "MY LAMP"
        lb.font = .systemFont(ofSize: 28, weight: .bold)
        lb.textColor = .darkNavy
        return lb
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "대한민국 지도에 나만의 흔적 남기기"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.textColor = .lightNavy
        return lb
    }()
    
    private lazy var mapImageView: UIImageView = {
        let image = UIImage(named: "myLampMap")
        let uv = UIImageView(image: image)
        uv.layer.cornerRadius = 16
        uv.contentMode = .scaleAspectFit
        uv.layer.masksToBounds = true
        uv.isUserInteractionEnabled = true
        return uv
    }()
    
    @objc
    private func didTap() {
        delegate?.didSelectMyLampImage()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .greyshWhite
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        mapImageView.addGestureRecognizer(gesture)
        
        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
        labelStackView.spacing = 6
        
        let totalStackView = UIStackView(arrangedSubviews: [labelStackView, mapImageView])
        totalStackView.axis = .vertical
        totalStackView.alignment = .fill
        totalStackView.distribution = .fill
        totalStackView.spacing = 17
        
        [totalStackView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            labelStackView.heightAnchor.constraint(equalToConstant: 60),
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
