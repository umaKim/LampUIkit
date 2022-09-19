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
        self.imageUrl = ""
        self.markerType = .recommended
        self.cancellables = .init()
        super.init(frame: .init(x: 0, y: 0, width: width, height: height))
    }
    
    private var cancellables: Set<AnyCancellable>
    
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
                    }
                }
            }
            
        }
    }
    
    private var imageUrl: String
    private var markerType: MapMarkerType
    
    convenience init(of imageUrl: String, type markerType: MapMarkerType) {
        self.init()
        self.imageUrl = imageUrl
        self.markerType = markerType
        
        switch markerType {
        case .recommended:
            outerImageView.image = .init(named: "circleRecommended")
            
        case .destination:
            outerImageView.image = .init(named: "circleDestination")
            
        case .completed:
            outerImageView.image = .init(named: "circleCompleted")
        }
        
        self.contentImageView.layer.cornerRadius = CGFloat(self.width/2)
        self.contentImageView.clipsToBounds = true
        self.addSubview(self.contentImageView)
        self.contentImageView.frame = .init(x: 0, y: 0, width: self.width, height: self.height - 8)
        
        self.addSubview(self.outerImageView)
        self.outerImageView.frame = .init(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
