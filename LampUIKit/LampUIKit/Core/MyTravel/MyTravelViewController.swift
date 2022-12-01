//
//  MyTravelViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/16.
//

import UmaBasicAlertKit
import UIKit

protocol MyTravelViewControllerDelegate: AnyObject {
    func myTravelViewControllerDidTapDismiss()
    func myTravelViewControllerDidTapMapButton(_ location: RecommendedLocation)
    func myTravelViewControllerDidTapNavigation(_ location: RecommendedLocation)
}

final class MyTravelViewController: BaseViewController<MyTravelView, MyTravelViewModel>, Alertable {
    weak var delegate: MyTravelViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItems = [contentView.dismissButton]
        navigationController?.setLargeTitleColor(.midNavy)
        navigationController?.setNavigationBarHidden(false, animated: true)
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
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
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.categoryButton.scrollIndicator(to: scrollView.contentOffset)
    }
}

// MARK: - MyTravelCellDelegate
extension MyTravelViewController: MyTravelCellDelegate {
    func myTravelCellDelegateDidReceiveResponse(_ message: String) {
        self.showDefaultAlert(title: message)
    }
    func myTravelCellDelegateDidTapComplete(at index: Int) { }
    func myTravelCellDelegateDidTap(_ item: MyTravelLocation) {
        let viewModel = LocationDetailViewModel(item)
        let viewController = LocationDetailViewController(LocationDetailView(), viewModel)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    func myTravelCellDelegateDidTapDelete(at index: Int) { }
}
// MARK: - FavoriteCellDelegate
extension MyTravelViewController: FavoriteCellDelegate {
    func favoriteCellDidTap(_ item: MyBookMarkLocation) {
        let viewModel = LocationDetailViewModel(item)
        let viewController = LocationDetailViewController(LocationDetailView(), viewModel)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    func favoriteCellDidTapDelete(at index: Int) { }
}
// MARK: - CompletedTravelCellDelegate
extension MyTravelViewController: CompletedTravelCellDelegate {
    func completedTravelCellDidTap(_ item: MyCompletedTripLocation) {
        let viewModel = LocationDetailViewModel(item)
        let viewController = LocationDetailViewController(LocationDetailView(), viewModel)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    func completedTravelCellDidTapDelete(at index: Int) { }
}

// MARK: - LocationDetailViewControllerDelegate
extension MyTravelViewController: LocationDetailViewControllerDelegate {
    func locationDetailViewControllerDidTapNavigate(_ location: RecommendedLocation) {
        self.delegate?.myTravelViewControllerDidTapNavigation(location)
    }
    func locationDetailViewControllerDidTapDismissButton() { }
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation) {
        self.delegate?.myTravelViewControllerDidTapMapButton(location)
    }
    func locationDetailViewControllerDidTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension MyTravelViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        3
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyTravelCell.identifier,
                    for: indexPath
                ) as? MyTravelCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configure(MyTravelCellViewModel())
            return cell
        } else if indexPath.item == 1 {
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FavoriteCell.identifier,
                    for: indexPath
                ) as? FavoriteCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configure(FavoriteCellViewModel())
            return cell
        } else if indexPath.item == 2 {
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CompletedTravelCell.identifier,
                    for: indexPath
                ) as? CompletedTravelCell
            else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configure(CompletedTravelCellViewModel())
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyTravelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(width: UIScreen.main.width, height: collectionView.frame.height)
    }
}
