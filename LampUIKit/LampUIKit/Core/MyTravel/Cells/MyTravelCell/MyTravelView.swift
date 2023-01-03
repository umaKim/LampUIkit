//
//  MyTravelView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/12/23.
//

import UIKit

enum MyTravelViewAction: Actionable {
    
}

final class MyTravelView: BaseView<MyTravelViewAction> {
    private(set) var collectionView = BaseCollectionViewWithHeader<
        MyTravelCellHeaderCell,
        MyTravelCellCollectionViewCell
    >(.vertical)
    private(set) var refreshcontrol = UIRefreshControl()
    
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        collectionView.refreshControl = refreshcontrol
        showEmptyStateView(with: Message.emptyMyTravel)
        [collectionView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
