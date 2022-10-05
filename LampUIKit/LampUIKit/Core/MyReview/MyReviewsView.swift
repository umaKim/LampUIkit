//
//  ReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import Combine
import UIKit

enum MyReviewsViewAction: Actionable {
    case back
}

class MyReviewsView: BaseView<MyReviewsViewAction> {

    private(set) lazy var backButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyReviewCollectionViewCell.self, forCellWithReuseIdentifier: MyReviewCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        return cv
    }()
    
    override init() {
        super.init()
        
        backButton.tapPublisher.sink {[weak self] _ in
            self?.sendAction(.back)
        }
        .store(in: &cancellables)
        
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
