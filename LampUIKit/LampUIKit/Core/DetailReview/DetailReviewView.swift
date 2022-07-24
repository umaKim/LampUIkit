//
//  DetailReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//
import Combine
import UIKit

enum DetailReviewViewAction {
    
}

class DetailReviewView: BaseWhiteView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<DetailReviewViewAction, Never>()
    
    private(set) var reportButton: UIBarButtonItem = .init(image: UIImage(named: ""), style: .done, target: nil, action: nil)
    
    private(set) var collectionView: UICollectionView = {
       let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(DetailReviewCollectionViewHeader.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: DetailReviewCollectionViewHeader.identifier)
        cv.register(DetailReviewViewCollectionViewCell.self,
                    forCellWithReuseIdentifier: DetailReviewViewCollectionViewCell.identifier)
        return cv
    }()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
    }
    
    private func setupUI() {
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
}

class DetailReviewCollectionViewHeader: UICollectionReusableView {
    static let identifier = "DetailReviewCollectionViewHeader"
    
    private let profileView: LocationRectangleProfileView = {
       let uv = LocationRectangleProfileView()
        uv.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return uv
    }()
    
    private let starRatingView: UIView = {
       let uv = UIView()
        uv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return uv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .greyshWhite
        
        let sv = UIStackView(arrangedSubviews: [profileView, starRatingView])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DetailReviewViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "DetailReviewViewCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
