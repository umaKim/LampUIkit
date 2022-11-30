//
//  RecommendedLocationView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/08/25.
//
import Combine
import CombineCocoa
import UIKit

enum RecommendedLocationViewAction: Actionable {
    case search
    case myCharacter
    case myTravel
}

class RecommendedLocationView: BaseView<RecommendedLocationViewAction> {
    private(set) lazy var customNavigationbar = CustomNavigationBarView()
    private(set) var collectionView = BaseCollectionView<SearchRecommendationCollectionViewCell>(.vertical, 18)
    private(set) lazy var searchButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "Search"), for: .normal)
        return button
    }()
    private(set) lazy var travelButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "myTravel"), for: .normal)
        return button
    }()
    private(set) lazy var myCharacter: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "myCharacter"), for: .normal)
        return button
    }()
    public func updateCustomNavigationBarTitle(_ text: String) {
        customNavigationbar.updateTitle(text)
    }
    override init() {
        super.init()
        bind()
        setupUI()
    }
    private func bind() {
        searchButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.sendAction(.search)
            }
            .store(in: &cancellables)
        travelButton
            .tapPublisher
            .sink {[weak self] _ in
                self?.sendAction(.myTravel)
            }
            .store(in: &cancellables)
        myCharacter
            .tapPublisher
            .sink {[weak self] _ in
                self?.sendAction(.myCharacter)
            }
            .store(in: &cancellables)
    }
    private func setupUI() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.contentInset = .init(top: 16, left: 0, bottom: 80, right: 0)
        showEmptyStateView(with: Message.emptyRecommended)
        customNavigationbar.setRightSideItems([searchButton, travelButton, myCharacter])
        [customNavigationbar, collectionView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            customNavigationbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            customNavigationbar.topAnchor.constraint(equalTo: topAnchor),
            customNavigationbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: customNavigationbar.bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
