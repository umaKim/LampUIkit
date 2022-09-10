//
//  DetailReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//
import SwiftUI
import Combine
import UIKit

enum ReviewViewAction {
    case back
}

class ReviewView: BaseWhiteView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<ReviewViewAction, Never>()

    private(set) lazy var backButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) var reportButton: UIBarButtonItem = .init(image: UIImage(named: ""), style: .done, target: nil, action: nil)
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(ReviewCollectionViewHeader.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: ReviewCollectionViewHeader.identifier)
        cv.register(ReviewViewCollectionViewCell.self,
                    forCellWithReuseIdentifier: ReviewViewCollectionViewCell.identifier)
        
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
        backButton.tapPublisher.sink {[weak self] _ in
            self?.actionSubject.send(.back)
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

class ReviewCollectionViewHeader: UICollectionReusableView {
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
    
    private lazy var satisfyView: ReviewLabel = ReviewLabel(title: "만족도", subTitle: "", titleTextColor: .midNavy)
    private lazy var atmosphereView: ReviewLabel = ReviewLabel(title: "분위기", subTitle: "", titleTextColor: .midNavy)
    private lazy var surroundingView: ReviewLabel = ReviewLabel(title: "주차 및 주변", subTitle: "", titleTextColor: .midNavy)
    private lazy var foodView: ReviewLabel = ReviewLabel(title: "먹거리", subTitle: "", titleTextColor: .midNavy)
    
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

protocol ReviewViewCollectionViewCellDelegate: AnyObject {
    func ReviewViewCollectionViewCellDidTapLikeButton(_ index: Int)
    func ReviewViewCollectionViewCellDidTapUnlikeButton(_ index: Int)
    func ReviewViewCollectionViewCellDidTapReportButton(_ index: Int)
}

class ReviewViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "DetailReviewViewCollectionViewCell"
    
    weak var delegate: ReviewViewCollectionViewCellDelegate?
    
    private lazy var imageView: UIImageView = {
        let uv = UIImageView()
        uv.layer.cornerRadius = 6
        uv.clipsToBounds = true
        uv.contentMode = .scaleAspectFill
        uv.backgroundColor = .lightNavy
        uv.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return uv
    }()
    
    private lazy var starRatinView: UIImageView = {
        let uv = UIImageView()
        uv.contentMode = .scaleAspectFit
        uv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return uv
    }()
    
    private lazy var commentLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkNavy
        lb.textAlignment = .natural
        lb.numberOfLines = 0
        lb.sizeToFit()
        lb.font = .systemFont(ofSize: 10, weight: .semibold)
        return lb
    }()
    
    private lazy var likeButton: UIButton = {
        var config = UIButton.Configuration.tinted()
        config.baseBackgroundColor = .midNavy
        config.cornerStyle = .capsule
        let image = UIImage(systemName: "heart")?.withTintColor(.red, renderingMode: .alwaysOriginal).resize(to: 10)
        config.image = image
        config.imagePlacement = .leading
        config.imagePadding = 6
        
        let bt = UIButton(configuration: config)
        bt.frame = .init(x: 0, y: 0, width: 62, height: 21)
        return bt
    }()
    
    private lazy var reportButton: UIButton = {
       let bt = UIButton()
        bt.layer.cornerRadius = 21/2
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.systemGray.cgColor
        bt.titleLabel?.font = .robotoMedium(9)
        bt.setTitle("신고하기".localized, for: .normal)
        bt.setTitleColor(UIColor.systemGray, for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 52).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 21).isActive = true
        return bt
    }()
    
    private var cancellables: Set<AnyCancellable>
    
    private func bind() {
        likeButton.tapPublisher.sink {[weak self] _ in
            guard
                let self = self,
                let reviewData = self.reviewData
            else {return }
            
            HapticManager.shared.feedBack(with: .heavy)
            self.likeButton.isSelected.toggle()
            if self.likeButton.isSelected {
                if reviewData.reviewILiked {
                    let numLiked = self.reviewData?.numLiked
                    self.likeButton.configuration?.subtitle = "\(numLiked ?? 0)"
                } else {
                    let numLiked = (reviewData.numLiked) + 1
                    self.likeButton.configuration?.subtitle = "\(numLiked)"
                }
                self.delegate?.ReviewViewCollectionViewCellDidTapLikeButton(self.tag)
            } else {
                let numLiked = (reviewData.numLiked) - 1
                self.likeButton.configuration?.subtitle = "\(numLiked)"
                self.delegate?.ReviewViewCollectionViewCellDidTapUnlikeButton(self.tag)
            }
        }
        .store(in: &cancellables)
        
        reportButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return }
                HapticManager.shared.feedBack(with: .heavy)
                self.reportButton.isSelected.toggle()
                self.delegate?.ReviewViewCollectionViewCellDidTapReportButton(self.tag)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        clipsToBounds = true
        
        let commentLabelSv = UIStackView(arrangedSubviews: [commentLabel])
        commentLabelSv.axis = .horizontal
        commentLabelSv.alignment = .top
        commentLabelSv.distribution = .fill
        
        let buttonSv = UIStackView(arrangedSubviews: [likeButton, reportButton])
        buttonSv.alignment = .fill
        buttonSv.distribution = .equalSpacing
        buttonSv.axis = .horizontal
        
        let starSv = UIStackView(arrangedSubviews: [starRatinView])
        starSv.axis = .vertical
        starSv.distribution = .fillProportionally
        starSv.alignment = .leading
        
        let sv = UIStackView(arrangedSubviews: [imageView, starSv, commentLabelSv, buttonSv])
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
    
    private var reviewData: ReviewData?
    
    public func configure(_ review: ReviewData) {
        self.reviewData = review
        
        let url = URL(string: (review.photoUrlArray?.first ?? ""))
        imageView.sd_setImage(with: url, placeholderImage: .placeholder)
        
        if let star = Double(review.star ?? "0") {
            starRatinView.image = .init(named: "\(star)")
        } else {
            starRatinView.image = .init(named: "0")
        }
        
        commentLabel.text = review.content
        likeButton.configuration?.subtitle = "\(review.numLiked)"
        likeButton.isSelected = review.reviewILiked
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
