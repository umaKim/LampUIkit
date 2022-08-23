//
//  CustomMarkerView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/22.
//

import UIKit

class CustomMarkerView: UIView {
    
    private let outerImageView: UIImageView = {
       let uv = UIImageView()
        uv.image = UIImage(named: "circleRecommended")
        return uv
    }()
    
    private let contentImageView: UIImageView = {
       let uv = UIImageView()
        uv.contentMode = .scaleAspectFill
        return uv
    }()
    
    private let width = 55
    private let height = 60
    
    init() {
        super.init(frame: .init(x: 0, y: 0, width: width, height: height))
    }
    
    convenience init(of imageUrl: String) {
        self.init()
        guard let url = URL(string: imageUrl) else { return }
        contentImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        contentImageView.layer.cornerRadius = CGFloat(width/2)
        contentImageView.clipsToBounds = true
        addSubview(contentImageView)
        contentImageView.frame = .init(x: 0, y: 0, width: width, height: height - 8)
        
        addSubview(outerImageView)
        outerImageView.frame = .init(x: 0, y: 0, width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
