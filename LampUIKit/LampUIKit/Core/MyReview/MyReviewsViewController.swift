//
//  ReviewViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import UIKit

protocol MyReviewsViewControllerDelegate: AnyObject {
    func MyReviewsViewControllerDidTapBack()
}

class MyReviewsViewController: BaseViewController<MyReviewsView, MyReviewsViewModel> {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UserReviewData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UserReviewData>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    weak var delegate: MyReviewsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 여행 후기".localized
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        navigationController?.navigationBar.barTintColor = .greyshWhite
        
        contentView.actionPublisher.sink { action in
            switch action {
            case .back:
                self.delegate?.MyReviewsViewControllerDidTapBack()
            }
        }
        .store(in: &cancellables)
        
        viewModel.notifyPublisher.sink {[weak self] noti in
            switch noti {
            case .reload:
                self?.updateSections()
            }
        }
        .store(in: &cancellables)
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.datum)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {[weak self] in
            guard let self = self else {return}
            self.view.showEmptyStateView(on: self.contentView.collectionView,
                                         when: self.viewModel.datum.isEmpty,
                                         with:  Message.emptyMyReviews)
        })
    }
    
    private func configureCollectionView() {
        contentView.collectionView.delegate = self
        
        dataSource = DataSource(collectionView: contentView.collectionView,
                                cellProvider: { collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyReviewCollectionViewCell.identifier, for: indexPath) as? MyReviewCollectionViewCell
            else { return UICollectionViewCell() }
            cell.tag = indexPath.item
            cell.delegate = self
            cell.configure(with: self.viewModel.datum[indexPath.item])
            return cell
        })
    }
    
    deinit {
        self.view.restoreViews()
    }
}

extension MyReviewsViewController: MyReviewCollectionViewCellDelegate {
    func MyReviewCollectionViewCellDidTapDelete(_ index: Int) {
        viewModel.deleteReview(at: index)
    }
}

extension MyReviewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.feedBack(with: .medium)
        let model = viewModel.datum[indexPath.item]
        let vm = ReviewDetailViewModel(.init(photoUrlArray: model.photoUrl,
                                             content: model.content))
        let vc = ReviewDetailViewController(ReviewDetailView(), vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyReviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.width - 32, height: 380)
    }
}
