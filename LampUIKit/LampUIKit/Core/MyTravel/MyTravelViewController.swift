//
//  MyTravelViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import UIKit

protocol MyTravelViewControllerDelegate: AnyObject {
    func myTravelViewControllerDidTapDismiss()
    func myTravelViewControllerDidTapMapButton(_ location: RecommendedLocation)
    func myTravelViewControllerDidTapNavigation(_ location: RecommendedLocation)
}

final class MyTravelViewController: BaseViewContronller {
    private let contentView = MyTravelView()
    
    private let viewModel: MyTravelViewModel
    
    weak var delegate: MyTravelViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    init(vm: MyTravelViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .always
        
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        
        navigationItem.leftBarButtonItems = [contentView.dismissButton]
        navigationController?.setLargeTitleColor(.midNavy)
        
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .dismiss:
                    self.delegate?.myTravelViewControllerDidTapDismiss()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .reload:
                    self.contentView.reload()
                }
            }
            .store(in: &cancellables)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.categoryButton.scrollIndicator(to: scrollView.contentOffset)
    }
}

extension MyTravelViewController: MyTravelCellDelegate {
    func myTravelCellDelegateDidTapComplete(at index: Int) {
        viewModel.completeTrip(at: index)
    }
    
    func myTravelCellDelegateDidTap(_ item: MyTravelLocation) {
        let vm = LocationDetailViewModel(item)
        let vc = LocationDetailViewController(vm: vm)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func myTravelCellDelegateDidTapDelete(at index: Int) {
        viewModel.deleteMyTravel(at: index)
    }
}

extension MyTravelViewController: FavoriteCellDelegate {
    func favoriteCellDidTap(_ item: MyBookMarkLocation) {
        let vm = LocationDetailViewModel(item)
        let vc = LocationDetailViewController(vm: vm)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func favoriteCellDidTapDelete(at index: Int) {
        viewModel.deleteMySaveLocations(at: index)
    }
}

//MARK: - CompletedTravelCellDelegate
extension MyTravelViewController: CompletedTravelCellDelegate {
    func completedTravelCellDidTap(_ item: MyCompletedTripLocation) {
        let vm = LocationDetailViewModel(item)
        let vc = LocationDetailViewController(vm: vm)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func completedTravelCellDidTapDelete(at index: Int) {
//        viewModel.deleteMyTravel(at: index)
    }
}

extension MyTravelViewController: LocationDetailViewControllerDelegate {
    func locationDetailViewControllerDidTapNavigate(_ location: RecommendedLocation) {
        self.delegate?.myTravelViewControllerDidTapNavigation(location)
    }
    
    func locationDetailViewControllerDidTapDismissButton() {
        
    }
    
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation) {
        self.delegate?.myTravelViewControllerDidTapMapButton(location)
    }
    
    func locationDetailViewControllerDidTapBackButton() {
        self.navigationController?.popViewController(animated: true)
        self.viewModel.fetch()
    }
}

extension MyTravelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTravelCell.identifier, for: indexPath) as? MyTravelCell
            else { return UICollectionViewCell() }
            cell.configure(models: viewModel.model.myTravel)
            cell.delegate = self
            return cell
            
        } else if indexPath.item == 1 {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell
            else { return UICollectionViewCell() }
            cell.configure(models: viewModel.model.favoriteTravel)
            cell.delegate = self
            return cell
            
        } else if indexPath.item == 2 {
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedTravelCell.identifier, for: indexPath) as? CompletedTravelCell
            else { return UICollectionViewCell() }
            cell.configure(models: viewModel.model.completedTravel)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MyTravelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width, height: collectionView.frame.height)
    }
}
