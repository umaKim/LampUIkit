//
//  CustomBalloonView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/14.
//

import UIKit

class CustomBalloonView: UIView {
    private lazy var padding: CGFloat = 8
    
    private lazy var imageView: UIImageView = {
        let uv = UIImageView()
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        return uv
    }()
    
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
    
    private lazy var backgroundImageView: UIImageView = {
        let uv = UIImageView(image: UIImage(named: "balloon"))
        return uv
    }()
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 100))
//        super.init(frame: .init(x: 0, y: 0, width: 400, height: 200))
        
        layer.cornerRadius = 6
    }
    
    convenience init(title: String, subtitle: String) {
        self.init()
        
        titleLabel.text = title
        addrLabel.text = subtitle
        
        let labelSv = UIStackView(arrangedSubviews: [titleLabel, addrLabel])
        labelSv.axis = .vertical
        labelSv.alignment = .center
        labelSv.distribution = .fillProportionally
        labelSv.frame = .init(x: 8,
                         y: 8,
                         width: frame.width - 16,
                         height: frame.height - 32)
        
        [backgroundImageView, labelSv].forEach { uv in
            addSubview(uv)
        }
        
        backgroundImageView.frame = frame
    }
    
    convenience init(title: String, subtitle: String, imageUrlString: String? = nil) {
        self.init()
        frame = .init(x: 0, y: 0, width: 300, height: 150)
        
        imageView.sd_setImage(with: URL(string: imageUrlString ?? ""),
                              placeholderImage: UIImage(named: "placeholder"))
        
        titleLabel.text = title
        addrLabel.text = subtitle
        
        print(title)
        print(subtitle)
        
        let labelSv = UIStackView(arrangedSubviews: [titleLabel, addrLabel])
        labelSv.axis = .vertical
        labelSv.alignment = .center
        labelSv.distribution = .fillEqually
        
        let totalSv = UIStackView(arrangedSubviews: [imageView, labelSv])
        totalSv.axis = .horizontal
        totalSv.alignment = .fill
        totalSv.distribution = .fillEqually
        totalSv.spacing = 8
        totalSv.frame = .init(x: 8,
                              y: 8,
                              width: frame.width - 16,
                              height: frame.height - 44)
        
        [backgroundImageView, totalSv].forEach { uv in
            addSubview(uv)
        }
        
        backgroundImageView.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
