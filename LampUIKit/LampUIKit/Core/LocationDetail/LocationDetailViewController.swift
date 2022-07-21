//
//  LocationDetailViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/19.
//
import Combine
import UIKit

final class LocationDetailViewController: BaseViewContronller {
    private let contentView = LocationDetailView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    private let viewModel: LocationDetailViewModel
    
    init(vm: LocationDetailViewModel) {
        self.viewModel = vm
        super.init()
        
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LocationDetailViewController: LocationDetailViewHeaderCellDelegate {
    func locationDetailViewHeaderCellDidTapSave() {
        
    }
    
    func locationDetailViewHeaderCellDidTapReview() {
        let vm = WriteReviewViewModel()
        let vc = WriteReviewViewController(vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func locationDetailViewHeaderCellDidTapAr() {
        
    }
    
    func locationDetailViewHeaderCellDidTapShare() {
        
    }
}

extension LocationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LocationDetailViewHeaderCell.identifier, for: indexPath) as! LocationDetailViewHeaderCell
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationDetailViewBodyCell.identifier, for: indexPath) as? LocationDetailViewBodyCell else {return UICollectionViewCell()}
        return cell
    }
}

extension LocationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: UIScreen.main.height / 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width, height: UIScreen.main.height / 3)
    }
}
