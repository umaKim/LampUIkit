//
//  TotalTravelReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/16.
//
import CombineCocoa
import Combine
import UIKit

enum TotalTravelReviewViewAction {
    case showDetail
}

class TotalTravelReviewView: UIView {
    private(set) lazy var actionPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<TotalTravelReviewViewAction, Never>()
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "이 곳의 여행 후기".localized
        label.textColor = .darkNavy
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private lazy var showDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "showDetail".localized), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return button
    }()
    private lazy var satisfyView = ReviewLabel(title: "만족도", subTitle: "만족", setRoundDesign: false)
    private lazy var atmosphereView = ReviewLabel(title: "분위기", subTitle: "만족", setRoundDesign: false)
    private lazy var surroundingView = ReviewLabel(title: "주차 및 주변", subTitle: "만족", setRoundDesign: false)
    private lazy var foodView = ReviewLabel(title: "먹거리", subTitle: "만족", setRoundDesign: false)
    private let dividerView = DividerView()
    private lazy var loadingView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        return activity
    }()
    public func showSkeleton() {
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    public func hideSkeleton() {
        backgroundColor = .clear
        loadingView.isHidden = true
        loadingView.stopAnimating()
    }
    public func configure(_ locationDetail: LocationDetailData) {
        guard let rate = locationDetail.totalAvgReviewRate else { return }
        let satisfactionIndex = rate.satisfaction ?? 0
        let moodIndex = rate.mood ?? 0
        let surroundIndex = rate.surround ?? 0
        let foodIndex = rate.foodArea ?? 0
        if satisfactionIndex == 0 {
            satisfyView.setSubtitle("-")
        } else {
            satisfyView.setSubtitle(RatingStandard.comfort[satisfactionIndex])
        }
        if moodIndex == 0 {
            atmosphereView.setSubtitle("-")
        } else {
            atmosphereView.setSubtitle(RatingStandard.atmosphere[moodIndex])
        }
        if surroundIndex == 0 {
            surroundingView.setSubtitle("-")
        } else {
            surroundingView.setSubtitle(RatingStandard.surrounding[surroundIndex])
        }
        if foodIndex == 0 {
            foodView.setSubtitle("-")
        } else {
            foodView.setSubtitle(RatingStandard.food[foodIndex])
        }
    }
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        bind()
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func bind() {
        showDetailButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.showDetail)
            }
            .store(in: &cancellables)
    }
    private var cancellables: Set<AnyCancellable>
    private func setupUI() {
        layer.cornerRadius = 8
        clipsToBounds = true
        let verticalSv = UIStackView(arrangedSubviews: [satisfyView, atmosphereView, surroundingView, foodView])
        verticalSv.axis = .vertical
        verticalSv.alignment = .leading
        verticalSv.distribution = .fillEqually
        verticalSv.spacing = 21
        let headerSv = UIStackView(arrangedSubviews: [titleLabel, showDetailButton])
        headerSv.axis = .horizontal
        headerSv.alignment = .fill
        headerSv.distribution = .fill
        let verticalStackView = UIStackView(arrangedSubviews: [headerSv, verticalSv])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fill
        verticalStackView.spacing = 18
        [verticalStackView, dividerView, loadingView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
