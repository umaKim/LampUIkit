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
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        label.font = .robotoBold(15)
        label.textAlignment = .center
        return label
    }()
    private lazy var addrLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(13)
        label.numberOfLines = 2
        label.textColor = .midNavy
        label.textAlignment = .center
        return label
    }()
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "balloon"))
        return imageView
    }()
    init() {
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 100))
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
                              placeholderImage: .placeholder)
        titleLabel.text = title
        addrLabel.text = subtitle
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
        [backgroundImageView, totalSv].forEach { uiView in
            addSubview(uiView)
        }
        backgroundImageView.frame = frame
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
