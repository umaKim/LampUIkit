//
//  ReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import Combine
import UIKit

enum MyReviewsViewAction: Actionable {
    case back
}

class MyReviewsView: BaseView<MyReviewsViewAction> {

    private(set) lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return button
    }()
    private(set) lazy var collectionView = BaseCollectionView<MyReviewCollectionViewCell>()
    override init() {
        super.init()
        bind()
        setupUI()
    }
    private func bind() {
        backButton
            .tapPublisher
            .sink {[weak self] _ in
            self?.sendAction(.back)
        }
        .store(in: &cancellables)
    }
    private func setupUI() {
        [collectionView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
