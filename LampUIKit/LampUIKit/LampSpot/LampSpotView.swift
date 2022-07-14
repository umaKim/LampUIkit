//
//  LampSpotView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/13.
//

import UIKit

extension UIImage {
    static let camera = UIImage(systemName: "camera")
    static let bell = UIImage(systemName: "bell")
}

class LampSpotView: UIView {
    
    private(set) var arButton = UIBarButtonItem(image: .camera, style: .done, target: nil, action: nil)
    private(set) var bellButton = UIBarButtonItem(image: .bell, style: .done, target: nil, action: nil)
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyMapCollectionViewCell.self, forCellWithReuseIdentifier: MyMapCollectionViewCell.identifier)
        cv.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
        cv.register(PopularLampSpotCollectionViewCell.self, forCellWithReuseIdentifier: PopularLampSpotCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    init() {
        super.init(frame: .zero)
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
