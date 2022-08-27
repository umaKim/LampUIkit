//
//  ReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import UIKit

class MyReviewsView: BaseWhiteView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private(set) lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyReviewHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: MyReviewHeaderCell.identifier)
        cv.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: MyReviewCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    override init() {
        super.init()
        
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

class MyReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyReviewCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyReviewHeaderCell: UICollectionReusableView {
    static let identifier = "MyReviewHeaderCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }
    
    public func configure() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
