//
//  ReviewDetailViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//

import UIKit

class ReviewDetailViewController: BaseViewController<ReviewDetailView, ReviewDetailViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
        contentView.configure(with: viewModel.data)
    }
}

extension ReviewDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewDetailImageCollectionViewCell.identifier, for: indexPath) as? ReviewDetailImageCollectionViewCell
        else {return UICollectionViewCell() }
        cell.configure(with: viewModel.data.photoUrlArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data.photoUrlArray.count
    }
}

extension ReviewDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width, height: UIScreen.main.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
