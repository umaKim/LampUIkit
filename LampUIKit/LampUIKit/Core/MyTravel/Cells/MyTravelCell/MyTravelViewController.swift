//
//  MyTravelViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/12/23.
//
import Combine
import HapticManager
import UIKit

protocol MyTravelViewControllerDelegate: AnyObject {
    func myTravelCellDelegateDidTap(_ item: MyTravelLocation)
    func myTravelCellDelegateDidTapDelete(at index: Int)
    func myTravelCellDelegateDidTapComplete(at index: Int)
    func myTravelCellDelegateDidReceiveResponse(_ message: String)
}

final class MyTravelViewController: BaseViewController<MyTravelView, MyTravelCellViewModel> {
    weak var delegate: MyTravelViewControllerDelegate?
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MyTravelLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyTravelLocation>
    enum Section { case main }
    private var dataSource: DataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
}

// MARK: - Bind
extension MyTravelViewController {
    private func bind() {
        viewModel
            .notifyPublisher
            .sink(receiveValue: {[weak self] notification in
                guard let self = self else {return }
                switch notification {
                case .reload:
                    self.updateSections()
                case .showMessage(let message):
                    self.delegate?.myTravelCellDelegateDidReceiveResponse(message)
                case .endRefreshing:
                    self.contentView.refreshcontrol.endRefreshing()
                }
            })
            .store(in: &cancellables)
        contentView
            .refreshcontrol
            .isRefreshingPublisher
            .sink {[weak self] isRefreshing in
                guard let self = self else {return }
                if isRefreshing {
                    self.viewModel.setIsRefreshing = true
                    self.fetchMyTravel()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Public
extension MyTravelViewController {
    private func fetchMyTravel() {
        viewModel.fetchMyTravel()
    }
    public func deleteMyTravel(at index: Int) {
        viewModel.deleteMyTravel(at: index)
    }
    public func completeTrip(at index: Int) {
        viewModel.completeTrip(at: index)
    }
}

// MARK: - MyTravelCellHeaderCellDelegate
extension MyTravelViewController: MyTravelCellHeaderCellDelegate {
    func myTravelCellHeaderCellDidSelectComplete() {
        viewModel.toggleShowDeleteButton
        contentView.collectionView.reloadData()
    }
    func myTravelCellHeaderCellDidSelectEdit() {
        viewModel.toggleShowDeleteButton
        contentView.collectionView.reloadData()
    }
}

// MARK: - MyTravelCellCollectionViewCellDelegate
extension MyTravelViewController: MyTravelCellCollectionViewCellDelegate {
    func myTravelCellCollectionViewCellDidTapComplete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.completeTrip(at: index)
        }
    }
    func myTravelCellCollectionViewCellDidTapDelete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.deleteMyTravel(at: index)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MyTravelViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.feedBack(with: .heavy)
        delegate?.myTravelCellDelegateDidTap(viewModel.models[indexPath.item])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyTravelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 254)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        32
    }
}

// MARK: - set up UI
extension MyTravelViewController {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.models)
        dataSource?.apply(
            snapshot,
            animatingDifferences: true,
            completion: { [weak self] in
                guard let self = self else { return }
                self.contentView.collectionView.backgroundColor = self.viewModel.models.isEmpty ? .clear : .greyshWhite
                self.contentView.collectionView.reloadData()
            })
    }
    private func configureCollectionView() {
        contentView.collectionView.delegate = self
        dataSource = DataSource(
            collectionView: contentView.collectionView
        ) {[weak self] collectionView, indexPath, _ in
            guard let self = self else { return .init() }
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyTravelCellCollectionViewCell.identifier,
                    for: indexPath
                ) as? MyTravelCellCollectionViewCell
            else { return .init() }
            cell.delegate = self
            cell.tag = indexPath.item
            cell.showDeleButton = self.viewModel.showDeleteButton
            cell.configure(self.viewModel.models[indexPath.item])
            return cell
        }
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyTravelCellHeaderCell.identifier,
                for: indexPath
            ) as? MyTravelCellHeaderCell
            view?.delegate = self
            return view
        }
    }
}
