//
//  LocationDetailView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import SkeletonView
import Combine
import UIKit

enum LocationDetailViewAction {
    case back
    case dismiss
    
    case save
    case ar
    case map
    case navigate
    case review
    
    case addToMyTrip
    case removeFromMyTrip
    
    case showDetailReview
}

final class LocationDetailView: BaseWhiteView {
    
    private(set) lazy var backButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var dismissButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .xmark, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<LocationDetailViewAction, Never>()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, String>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private lazy var locationImageView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        cv.delegate = self
        cv.backgroundColor = .greyshWhite
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private(set) var contentScrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView = UIView()
    
    private let buttonSv = LocationDetailViewHeaderCellButtonStackView()
    
    private let dividerView = DividerView()
    
    private let label1: LocationDescriptionView = LocationDescriptionView("", description: "")
    private let label2: LocationDescriptionView = LocationDescriptionView("", description: "")
    private let label3: LocationDescriptionView = LocationDescriptionView("", description: "")
    private let label4: LocationDescriptionView = LocationDescriptionView("", description: "")
    private let label5: LocationDescriptionView = LocationDescriptionView("", description: "")
    
    public func configureDetailInfo(_ locationDetail: LocationDetailData) {
        
        if locationDetail.contentTypeId == "12" {
            label1.configure("문의 안내", locationDetail.datailInfo?.infocenter ?? "")
            label2.configure("주차", locationDetail.datailInfo?.parking ?? "")
            label3.configure("쉬는 날", locationDetail.datailInfo?.restdate ?? "")
            label4.configure("운영시기", locationDetail.datailInfo?.useseason ?? "")
            label5.configure("운영시간", locationDetail.datailInfo?.usetime ?? "")
            return
        }
        
        if locationDetail.contentTypeId == "14" {
            label1.configure("할인정보", locationDetail.datailInfo?.discountinfo ?? "")
            label2.configure("문의 안내", locationDetail.datailInfo?.infocenterculture ?? "")
            label3.configure("쉬는 날", locationDetail.datailInfo?.restdateculture ?? "")
            label4.configure("비용", locationDetail.datailInfo?.usefee ?? "")
            label5.configure("운영 시간", locationDetail.datailInfo?.usetimeculture ?? "")
            return
        }
        
        if locationDetail.contentTypeId == "15" {
            label1.configure("행사 장소", locationDetail.datailInfo?.eventplace ?? "")
            label2.configure("행사 기간", locationDetail.datailInfo?.eventstartdate ?? "")
            label3.configure("행사 위치 안내", locationDetail.datailInfo?.placeinfo ?? "")
            label4.configure("공연 시간", locationDetail.datailInfo?.playtime ?? "")
            label5.configure("비용", locationDetail.datailInfo?.usetimefestival ?? "")
            return
        }
        
        if locationDetail.contentTypeId == "28" {
            label1.configure("문의 안내", locationDetail.datailInfo?.infocenterleports ?? "")
            label2.configure("개장 기간", locationDetail.datailInfo?.openperiod ?? "")
            label3.configure("쉬는 날", locationDetail.datailInfo?.restdateleports ?? "")
            label4.configure("이용 요금", locationDetail.datailInfo?.usefeeleports ?? "")
            label5.configure("이용 시간", locationDetail.datailInfo?.usetimeleports ?? "")
            return
        }
        
        if locationDetail.contentTypeId == "39" {
            label1.configure("문의 안내", locationDetail.datailInfo?.infocenterfood ?? "")
            label2.configure("대표 메뉴", locationDetail.datailInfo?.firstmenu ?? "")
            label3.configure("운영 시간", locationDetail.datailInfo?.opentimefood ?? "")
            label4.configure("쉬는 날", locationDetail.datailInfo?.restdatefood ?? "")
            label5.isHidden = true
            return
        }
        
        label1.isHidden = true
        label2.isHidden = true
        label3.isHidden = true
        label4.isHidden = true
        label5.isHidden = true
    }
    
    private func configureImageViewCollecitonView() {
        dataSource = DataSource(collectionView: locationImageView,
                                cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {return nil}
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(self.photoUrls[indexPath.item])
            cell.isDeleteButtonHidden = true
            return cell
        })
    }
    
    private var photoUrls: [String] = []
    private var photoUrlsForCell: [String] = []
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(photoUrlsForCell)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private lazy var addToMyTravelButton = RectangleTextButton("내 여행지로 추가", background: .midNavy, textColor: .white, fontSize: 17)
    
    private lazy var totalTravelReviewView = TotalTravelReviewView()
    
    public func configure(_ locationDetail: LocationDetailData) {
        
        buttonSv.configure(locationDetail.bookMark ?? false)
        
        if locationDetail.planExist?.num == 0 {
            addToMyTravelButton.isSelected = false
            addToMyTravelButton.update("내 여행지로 추가", background: .midNavy, textColor: .white)
        } else {
            addToMyTravelButton.isSelected = true
            addToMyTravelButton.update("내 여행지로 추가 취소", background: .systemGray, textColor: .white)
        }
        
        totalTravelReviewView.configure(locationDetail)
    }
    
    public func configure(with images: [String]) {
        photoUrls = images
        photoUrlsForCell = images.map({$0 + UUID().uuidString})
        updateSections()
    }
    
    public func showSkeleton() {
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        
        buttonSv.showSkeleton()
        
        label1.showSkeleton()
        label2.showSkeleton()
        label3.showSkeleton()
        label4.showSkeleton()
        label5.showSkeleton()
        
        addToMyTravelButton.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]),
                                                         animation: skeletonAnimation,
                                                         transition: .none)
    }
    
    public func hideSkeleton() {
        buttonSv.hideSkeleton()
        
        label1.hideSkeleton()
        label2.hideSkeleton()
        label3.hideSkeleton()
        label4.hideSkeleton()
        label5.hideSkeleton()
        
        addToMyTravelButton.hideSkeleton()
    }
    
    override init() {
        super.init()
        
        bind()
        setupUI()
        
        configureImageViewCollecitonView()
    }
    
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.back)
            }
            .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
        
        buttonSv
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                switch action {
                case .save:
                    self.actionSubject.send(.save)
                    
                case .ar:
                    self.actionSubject.send(.ar)
                    
                case .map:
                    self.actionSubject.send(.map)
                    
                case .navigation:
                    self.actionSubject.send(.navigate)
                    
                case .review:
                    self.actionSubject.send(.review)
                }
            }
            .store(in: &cancellables)
        
        addToMyTravelButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.addToMyTravelButton.isSelected.toggle()
                
                if self.addToMyTravelButton.isSelected {
                    self.addToMyTravelButton.update("내여행지로 추가 취소", background: .systemGray, textColor: .white)
                    self.actionSubject.send(.addToMyTrip)
                } else {
                    self.addToMyTravelButton.update("내여행지로 추가", background: .midNavy, textColor: .white)
                    self.actionSubject.send(.removeFromMyTrip)
                }
            }
            .store(in: &cancellables)
        
        totalTravelReviewView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .showDetail:
                    self.actionSubject.send(.showDetailReview)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)
        
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStackView = UIStackView(arrangedSubviews: [label1, label2, label3, label4, label5])
        labelStackView.alignment = .leading
        labelStackView.distribution = .fillProportionally
        labelStackView.spacing = 16
        labelStackView.axis = .vertical
        
        [
            locationImageView,
            buttonSv,
            dividerView,
            labelStackView,
            addToMyTravelButton,
            totalTravelReviewView
        ].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        buttonSv.isSkeletonable = true
        dividerView.isSkeletonable = true
        labelStackView.isSkeletonable = true
        addToMyTravelButton.isSkeletonable = true
        totalTravelReviewView.isSkeletonable = true
        
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            locationImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            locationImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.width / 1.5),
            
            buttonSv.topAnchor.constraint(equalTo: locationImageView.bottomAnchor),
            buttonSv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonSv.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonSv.heightAnchor.constraint(equalToConstant: 95),
            
            dividerView.topAnchor.constraint(equalTo: buttonSv.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            labelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelStackView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            
            addToMyTravelButton.topAnchor.constraint(equalTo: labelStackView.bottomAnchor, constant: 40),
            addToMyTravelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToMyTravelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToMyTravelButton.heightAnchor.constraint(equalToConstant: 60),
            
            totalTravelReviewView.topAnchor.constraint(equalTo: addToMyTravelButton.bottomAnchor, constant: 60),
            totalTravelReviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            totalTravelReviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            totalTravelReviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.width-32,
                     height: UIScreen.main.width / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
