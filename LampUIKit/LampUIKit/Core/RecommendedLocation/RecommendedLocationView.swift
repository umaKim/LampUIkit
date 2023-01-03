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

final class RecommendedLocationView: BaseView<RecommendedLocationViewAction> {
    // MARK: - UI Objects
    private(set) lazy var customNavigationbar = CustomNavigationBarView()
    private(set) var collectionView = SearchCollectionView()
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
    // MARK: - Init
    override init() {
        super.init()
        bind()
        setupUI()
    }
    public func updateCustomNavigationBarTitle(_ text: String) {
        customNavigationbar.updateTitle(text)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bind
extension RecommendedLocationView {
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
}

// MARK: - Set up UI
extension RecommendedLocationView {
    private func setupUI() {
        collectionView.keyboardDismissMode = .onDrag
        collectionView.contentInset = .init(top: 16, left: 0, bottom: 80, right: 0)
        showEmptyStateView(with: Message.emptyRecommended)
        customNavigationbar.setRightSideItems([searchButton, travelButton, myCharacter])
        addSubviews(customNavigationbar, collectionView)
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
}
