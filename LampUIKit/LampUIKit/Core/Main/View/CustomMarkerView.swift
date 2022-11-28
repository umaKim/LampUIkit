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
    
    private var imageUrl: String
    private var markerType: MapMaker
    
    init() {
        self.imageUrl = ""
        self.markerType = RecommendedMapMarker()
        super.init(frame: .init(x: 0, y: 0, width: width, height: height))
    }
    
    convenience init(
        of imageUrl: String,
        type markerType: MapMaker
    ) {
        self.init()
        self.imageUrl = imageUrl
        self.markerType = markerType
        
        setMarkerType(as: markerType)
        setupUI()
    }
    
    private func setMarkerType(as markerType: MapMaker) {
        outerImageView.image = markerType.image
//        switch markerType {
//        case .recommended:
//            outerImageView.image = .circleRecommended
//
//        case .destination:
//            outerImageView.image = .circleDestination
//
//        case .completed:
//            outerImageView.image = .circleCompleted
//        }
    }
    
    private func setupUI() {
        self.contentImageView.layer.cornerRadius = CGFloat(width/2)
        self.contentImageView.clipsToBounds = true
        self.addSubview(contentImageView)
        self.contentImageView.frame = .init(x: 0, y: 0, width: width, height: height - 8)
        
        self.addSubview(outerImageView)
        self.outerImageView.frame = .init(x: 0, y: 0, width: width, height: height)
    }
    
    public func configure(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            do {
                if let url = URL(string: self.imageUrl),
                   let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.contentImageView.image = .init(data: data)?.rounded(with: .clear,
                                                                                 width: 0)?.resize(to: 100)
                        completion()
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.contentImageView.image = .placeholder
                        completion()
                    }
                }
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
