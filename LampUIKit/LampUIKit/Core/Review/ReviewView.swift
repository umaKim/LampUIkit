//
//  DetailReviewView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//
import SwiftUI
import Combine
import UIKit

enum ReviewViewAction: Actionable {
    case back
}

class ReviewView: BaseView<ReviewViewAction> {
    private(set) lazy var backButton = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
    
    private(set) var collectionView = BaseCollectionViewWithHeader<ReviewCollectionViewHeader, ReviewViewCollectionViewCell>()
    
    override init() {
        super.init()
        
        bind()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
