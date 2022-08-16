//
//  CustomBalloonView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//

import UIKit

class CustomBalloonView: UIView {
    private lazy var padding: CGFloat = 8
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.numberOfLines = 2
        lb.font = .robotoBold(15)
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var addrLabel: UILabel = {
        let lb = UILabel()
        lb.font = .robotoBold(13)
        lb.numberOfLines = 2
        lb.textColor = .midNavy
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var sv: UIStackView = {
        let sv = UIStackView(frame: self.frame)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillProportionally
        return sv
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let uv = UIImageView(image: UIImage(named: "balloon"))
        return uv
    }()
    
    init(location: RecommendedLocation) {
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 100))
        
        titleLabel.text = location.title
        addrLabel.text = location.addr
        
        layer.cornerRadius = 6
        
        let labelSv = UIStackView(arrangedSubviews: [titleLabel, addrLabel])
        labelSv.axis = .vertical
        labelSv.alignment = .center
        labelSv.distribution = .fillProportionally
        labelSv.frame = .init(x: 8,
                         y: 8,
                         width: frame.width - 16,
                         height: frame.height - 32)
        
        [labelSv].forEach { uv in
            sv.addArrangedSubview(uv)
        }
        
        [backgroundImageView, sv].forEach { uv in
            addSubview(uv)
        }
        
        sv.frame = .init(x: 8,
                         y: 4,
                         width: frame.width - 16,
                         height: frame.height - 32)
        
        backgroundImageView.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
