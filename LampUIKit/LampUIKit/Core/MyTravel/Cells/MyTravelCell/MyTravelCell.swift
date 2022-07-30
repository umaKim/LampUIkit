//
//  MyTravelCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//
import Combine
import UIKit

final class MyTravelCell: UICollectionViewCell {
        setupUI()
}

extension MyTravelCell: MyTravelCellHeaderCellDelegate {
}

extension MyTravelCell: MyTravelCellCollectionViewCellDelegate {
}

extension MyTravelCell: UICollectionViewDelegateFlowLayout {
}

//MARK: - set up UI
extension MyTravelCell {
    private func setupUI() {
        configureCollectionView()
        
        backgroundColor = .systemCyan
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
