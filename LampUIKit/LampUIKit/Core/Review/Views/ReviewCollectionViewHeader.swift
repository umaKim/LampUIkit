//
//  ReviewCollectionViewHeader.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/10/07.
//

import SwiftUI
import UIKit

class ReviewCollectionViewHeader: UICollectionReusableView, HeaderCellable {
    static let identifier = "DetailReviewCollectionViewHeader"
    private let profileView: LocationRectangleProfileView = {
        let view = LocationRectangleProfileView()
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        return view
    }()
    private var delegate: ContentViewDelegate = ContentViewDelegate()
    private lazy var starRatingView: UIView = {
        guard
            let view = UIHostingController(
                rootView: CustomRatingBar(
                    axisMode: .horizontal,
                    interactionable: false,
                    delegate: delegate
                )
            ).view
        else {return UIView()}
        view.backgroundColor = .greyshWhite
        return view
    }()
    private lazy var satisfyView: ReviewLabel = ReviewLabel(title: "만족도", subTitle: "", titleTextColor: .midNavy)
    private lazy var atmosphereView: ReviewLabel = ReviewLabel(title: "분위기", subTitle: "", titleTextColor: .midNavy)
    private lazy var surroundingView: ReviewLabel = ReviewLabel(title: "주차 및 주변", subTitle: "", titleTextColor: .midNavy)
    private lazy var foodView: ReviewLabel = ReviewLabel(title: "먹거리", subTitle: "", titleTextColor: .midNavy)
    private lazy var dividerView = DividerView()
    public func configure(_ location: RecommendedLocation, _ locationDetail: LocationDetailData) {
        profileView.configure(location)
        guard let rate = locationDetail.totalAvgReviewRate else { return }
        // MARK: - Star Rate
        delegate.starValue = rate.AVG ?? 0.0
        // MARK: - Detial Rate
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
        let stackView = UIStackView(arrangedSubviews: [profileView, starRatingView, verticalSv, dividerView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        [stackView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
