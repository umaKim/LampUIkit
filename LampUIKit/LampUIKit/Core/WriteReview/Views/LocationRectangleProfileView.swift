//
//  LocationRectangleProfileView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//

import UIKit

final class LocationRectangleProfileView: UIView {
    private lazy var profileImageView: UIImageView = {
        let uv = UIImageView()
        uv.image = .gear
        uv.widthAnchor.constraint(equalToConstant: 72).isActive = true
        return uv
    }()
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "경복궁"
        lb.textColor = .black
        lb.font = .robotoBold(15)
        return lb
    }()
    
    private lazy var addrLabel: UILabel = {
        let lb = UILabel()
        lb.text = "서울시 종로구 시작로 191"
        lb.textColor = .darkNavy
        lb.font = .robotoBold(12)
        return lb
    }()
    
    public func configure(_ location: RecommendedLocation) {
        let urlString = location.image
        let url = URL(string: urlString)
        profileImageView.sd_setImage(with: url)
        
        titleLabel.text = location.title
        addrLabel.text = location.addr
    }
    
    init() {
        super.init(frame: .zero)
        
        let labelSv = UIStackView(arrangedSubviews: [titleLabel, addrLabel])
        labelSv.axis = .vertical
        labelSv.distribution = .fill
        labelSv.alignment = .leading
        
        let totalSv = UIStackView(arrangedSubviews: [profileImageView, labelSv])
        totalSv.axis = .horizontal
        totalSv.distribution = .fill
        totalSv.alignment = .fill
       
        [totalSv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            totalSv.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalSv.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalSv.bottomAnchor.constraint(equalTo: bottomAnchor),
            totalSv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
