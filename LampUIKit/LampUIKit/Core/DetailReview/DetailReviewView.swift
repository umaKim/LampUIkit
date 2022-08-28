//
//  DetailReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//
import SwiftUI
import Combine
import UIKit

enum DetailReviewViewAction {
    case back
}

class DetailReviewView: BaseWhiteView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<DetailReviewViewAction, Never>()

    private(set) lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named:"back")?.withTintColor(.midNavy, renderingMode: .alwaysOriginal)
        let bt = UIBarButtonItem(image: image, style: .done, target: nil, action: nil)
        return bt
    }()
    
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
        
        cv.backgroundColor = .greyshWhite
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
        backButton.tapPublisher.sink { _ in
            self.actionSubject.send(.back)
        }
        .store(in: &cancellables)
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
    
    private var delegate: ContentViewDelegate = ContentViewDelegate()
    
    private lazy var starRatingView: UIView = {
        guard
            let uv = UIHostingController(rootView: CustomRatingBar(axisMode: .horizontal, interactionable: false, delegate: delegate)).view
        else {return UIView()}
        uv.backgroundColor = .greyshWhite
        return uv
    }()
    
    private lazy var satisfyView: ReviewLabel = ReviewLabel(title: "만족도", subTitle: "")
    private lazy var atmosphereView: ReviewLabel = ReviewLabel(title: "분위기", subTitle: "")
    private lazy var surroundingView: ReviewLabel = ReviewLabel(title: "주차 및 주변", subTitle: "")
    private lazy var foodView: ReviewLabel = ReviewLabel(title: "먹거리", subTitle: "")
    
    private lazy var dividerView = DividerView()
    
    public func configure(_ location: RecommendedLocation, _ locationDetail: LocationDetailData) {
        profileView.configure(location)
        
        guard let rate = locationDetail.totalAvgReviewRate else { return }
        //MARK: - Star Rate
        delegate.starValue = rate.AVG ?? 0.0
        
        //MARK: - Detial Rate
        let satisfactionIndex = rate.satisfaction ?? 0
        let moodIndex = rate.mood ?? 0
        let surroundIndex = rate.surround ?? 0
        let foodIndex = rate.foodArea ?? 0
        
        satisfyView.setSubtitle(RatingStandard.comfort[satisfactionIndex])
        atmosphereView.setSubtitle(RatingStandard.atmosphere[moodIndex])
        surroundingView.setSubtitle(RatingStandard.surrounding[surroundIndex])
        foodView.setSubtitle(RatingStandard.food[foodIndex])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .greyshWhite
        
        let verticalSv = UIStackView(arrangedSubviews: [satisfyView, atmosphereView, surroundingView, foodView])
        verticalSv.axis = .vertical
        verticalSv.alignment = .leading
        verticalSv.distribution = .fillEqually
        verticalSv.spacing = 21
        
        let sv = UIStackView(arrangedSubviews: [profileView, starRatingView, verticalSv, dividerView])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 16
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            sv.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DetailReviewViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "DetailReviewViewCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let uv = UIImageView()
        uv.backgroundColor = .blue
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        uv.contentMode = .scaleAspectFill
        uv.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return uv
    }()
    
    private lazy var starRatinView: UIView = {
        let uv = UIView()
        uv.backgroundColor = .green
        uv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return uv
    }()
    
    private lazy var commentLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .brown
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        clipsToBounds = true
        
        let sv = UIStackView(arrangedSubviews: [imageView, starRatinView, commentLabel])
        sv.distribution = .fill
        sv.alignment = .fill
        sv.axis = .vertical
        sv.spacing = 8
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 13),
            sv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13),
            sv.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            sv.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13)
        ])
    }
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        
        bind()
        setupUI()
    }
    
    public func configure(_ review: ReviewData) {
        let url = URL(string: (review.photoUrlArray.first ?? "") ?? "")
        imageView.sd_setImage(with: url, placeholderImage: .init(named: "placeholder"))
        if let star = Double(review.star) {
            starRatinView.image = .init(named: "\(star)")
        } else {
            starRatinView.image = .init(named: "0")
        }
        
        commentLabel.text = review.content
        likeButton.configuration?.subtitle = "\(review.numLiked ?? 0)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
