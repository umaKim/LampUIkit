//
//  ReviewDetailViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/09/05.
//

import UIKit

class ReviewDetailViewController: BaseViewContronller {
    
    private let contentView = ReviewDetailView()
    
    private let viewModel: ReviewDetailViewModel
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    init(vm: ReviewDetailViewModel) {
        self.viewModel = vm
        super.init()
        
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        contentView.collectionView.reloadData()
        contentView.configure(with: viewModel.data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReviewDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewDetailImageCollectionViewCell.identifier, for: indexPath) as? ReviewDetailImageCollectionViewCell
        else {return UICollectionViewCell() }
        cell.configure(with: viewModel.data.photoUrlArray?[indexPath.item] ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let url = viewModel.data.photoUrlArray {
            return url.count
        }
        return 0
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
