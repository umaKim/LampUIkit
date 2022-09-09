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
       let lb = UILabel()
        lb.text = "이 곳의 여행 후기".localized
        lb.textColor = .darkNavy
        lb.font = .systemFont(ofSize: 20, weight: .bold)
        return lb
    }()
    
    private lazy var showDetailButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "showDetail".localized), for: .normal)
        bt.widthAnchor.constraint(equalToConstant: 80).isActive = true
        bt.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return bt
    }()
    
    private lazy var satisfyView: ReviewLabel = {
        let uv = ReviewLabel(title: "만족도".localized, subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
    private lazy var atmosphereView: ReviewLabel = {
        let uv = ReviewLabel(title: "분위기".localized, subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
    private lazy var surroundingView: ReviewLabel = {
        let uv = ReviewLabel(title: "주차 및 주변".localized, subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
    private lazy var foodView: ReviewLabel = {
        let uv = ReviewLabel(title: "먹거리".localized, subTitle: "만족", setRoundDesign: false)
        return uv
    }()
    
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
        showDetailButton.tapPublisher.sink {[weak self] _ in
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
        
        let sv = UIStackView(arrangedSubviews: [headerSv, verticalSv])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 18
        
        [sv, dividerView, loadingView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            sv.topAnchor.constraint(equalTo: topAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
