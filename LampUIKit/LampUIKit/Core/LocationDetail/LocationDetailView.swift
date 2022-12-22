//
//  LocationDetailView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/20.
//
import HapticManager
import SkeletonView
import Combine
import UIKit

enum LocationDetailViewAction: Actionable {
    case back
    case dismiss
    case save
    case ar
    case map
    case review
    case addToMyTrip
    case removeFromMyTrip
    case showDetailReview
}

final class LocationDetailView: BaseView<LocationDetailViewAction> {
    private(set) lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return button
    }()
    private(set) lazy var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .xmark, style: .done, target: nil, action: nil)
        return button
    }()
    private lazy var locationImageView = ImageViewCollectionView()
    private(set) var contentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let contentView = UIView()
    private let buttonSv = LocationDetailViewHeaderCellButtonStackView()
    public func scrollToButtonSv() {
        contentScrollView.setContentOffset(.init(x: 0, y: locationImageView.frame.height + 16), animated: true)
    }
    private let dividerView = DividerView()
    private let label1 = LocationDescriptionView(
        "",
        description: "                                                     "
    )
    private let label2 = LocationDescriptionView(
        "",
        description: "                                                     "
    )
    private let label3 = LocationDescriptionView(
        "",
        description: "                                                     "
    )
    private let label4 = LocationDescriptionView(
        "",
        description: "                                                     "
    )
    private let label5 = LocationDescriptionView(
        "",
        description: "                                                     "
    )
    public func configureDetailInfo(_ locationDetail: LocationDetailData) {
        if locationDetail.contentTypeId == "12" || locationDetail.contentTypeId == "76" {
            label1.configure("문의 안내", locationDetail.datailInfo?.infocenter ?? "")
            label2.configure("주차", locationDetail.datailInfo?.parking ?? "")
            label3.configure("쉬는 날", locationDetail.datailInfo?.restdate ?? "")
            label4.configure("운영시기", locationDetail.datailInfo?.useseason ?? "")
            label5.configure("운영시간", locationDetail.datailInfo?.usetime ?? "")
            return
        }
        if locationDetail.contentTypeId == "14" || locationDetail.contentTypeId == "78" {
            label1.configure("할인정보", locationDetail.datailInfo?.discountinfo ?? "")
            label2.configure("문의 안내", locationDetail.datailInfo?.infocenterculture ?? "")
            label3.configure("쉬는 날", locationDetail.datailInfo?.restdateculture ?? "")
            label4.configure("비용", locationDetail.datailInfo?.usefee ?? "")
            label5.configure("운영 시간", locationDetail.datailInfo?.usetimeculture ?? "")
            return
        }
        if locationDetail.contentTypeId == "15" || locationDetail.contentTypeId == "85" {
            label1.configure("행사 장소", locationDetail.datailInfo?.eventplace ?? "")
            label2.configure("행사 기간", locationDetail.datailInfo?.eventstartdate ?? "")
            label3.configure("행사 위치 안내", locationDetail.datailInfo?.placeinfo ?? "")
            label4.configure("공연 시간", locationDetail.datailInfo?.playtime ?? "")
            label5.configure("비용", locationDetail.datailInfo?.usetimefestival ?? "")
            return
        }
        if locationDetail.contentTypeId == "28" || locationDetail.contentTypeId == "75" {
            label1.configure("문의 안내", locationDetail.datailInfo?.infocenterleports ?? "")
            label2.configure("개장 기간", locationDetail.datailInfo?.openperiod ?? "")
            label3.configure("쉬는 날", locationDetail.datailInfo?.restdateleports ?? "")
            label4.configure("이용 요금", locationDetail.datailInfo?.usefeeleports ?? "")
            label5.configure("이용 시간", locationDetail.datailInfo?.usetimeleports ?? "")
            return
        }
        if locationDetail.contentTypeId == "39" || locationDetail.contentTypeId == "82" {
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
    private lazy var addToMyTravelButton = RectangleTextButton(
        "내 여행지로 추가".localized,
        background: .clear,
        textColor: .white,
        fontSize: 17
    )
    private lazy var totalTravelReviewView = TotalTravelReviewView()
    public func configure(_ locationDetail: LocationDetailData) {
        buttonSv.configure(locationDetail.bookMark ?? false)
        if locationDetail.planExist?.num == 0 {
            addToMyTravelButton.isSelected = false
            addToMyTravelButton.update("내 여행지로 추가".localized, background: .lightNavy, textColor: .white)
        } else {
            addToMyTravelButton.isSelected = true
            addToMyTravelButton.update("내 여행지로 추가 취소".localized, background: .systemGray, textColor: .white)
        }
        totalTravelReviewView.configure(locationDetail)
    }
    public func configure(with images: [String]) {
        locationImageView.setupPhotoUrls(images.isEmpty ? ["placeholder"] : images)
        locationImageView.reloadData()
    }
    public func showSkeleton() {
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        buttonSv.showSkeleton()
        label1.showSkeleton()
        label2.showSkeleton()
        label3.showSkeleton()
        label4.showSkeleton()
        label5.showSkeleton()
        addToMyTravelButton.showAnimatedGradientSkeleton(
            usingGradient: .init(colors: [.lightGray, .gray]),
            animation: skeletonAnimation,
            transition: .none
        )
        totalTravelReviewView.showSkeleton()
    }
    public func hideSkeleton() {
        buttonSv.hideSkeleton()
        label1.hideSkeleton()
        label2.hideSkeleton()
        label3.hideSkeleton()
        label4.hideSkeleton()
        label5.hideSkeleton()
        addToMyTravelButton.hideSkeleton()
        totalTravelReviewView.hideSkeleton()
    }
    override init() {
        super.init()
        bind()
        setupUI()
    }
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                HapticManager.shared.feedBack(with: .heavy)
                self.sendAction(.back)
            }
            .store(in: &cancellables)
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else { return }
                HapticManager.shared.feedBack(with: .heavy)
                self.sendAction(.dismiss)
            }
            .store(in: &cancellables)
        buttonSv
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else { return }
                HapticManager.shared.feedBack(with: .heavy)
                switch action {
                case .save:
                    self.sendAction(.save)
                case .ar:
                    self.sendAction(.ar)
                case .map:
                    self.sendAction(.map)
                case .review:
                    self.sendAction(.review)
                }
            }
            .store(in: &cancellables)
        addToMyTravelButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                HapticManager.shared.feedBack(with: .heavy)
                self.addToMyTravelButton.isSelected.toggle()
                if self.addToMyTravelButton.isSelected {
                    self.addToMyTravelButton.update("내 여행지로 추가 취소".localized, background: .systemGray, textColor: .white)
                    self.sendAction(.addToMyTrip)
                } else {
                    self.addToMyTravelButton.update("내 여행지로 추가".localized, background: .lightNavy, textColor: .white)
                    self.sendAction(.removeFromMyTrip)
                }
            }
            .store(in: &cancellables)
        totalTravelReviewView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .showDetail:
                    self.sendAction(.showDetailReview)
                }
            }
            .store(in: &cancellables)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set up UI
extension LocationDetailView {
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
        locationImageView.backgroundColor = .greyshWhite
        locationImageView.clipsToBounds = true
        locationImageView.layer.cornerRadius = 6
        [
            locationImageView,
            buttonSv,
            dividerView,
            labelStackView,
            addToMyTravelButton,
            totalTravelReviewView
        ].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uiView)
        }
        dividerView.isSkeletonable = true
        addToMyTravelButton.isSkeletonable = true
        totalTravelReviewView.isSkeletonable = true
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            locationImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            locationImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.width - 32),
            locationImageView.heightAnchor.constraint(equalToConstant: 280),
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
}
