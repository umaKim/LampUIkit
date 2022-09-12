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

class MyReviewsViewController: BaseViewContronller {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UserReviewData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UserReviewData>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private let contentView = MyReviewsView()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    weak var delegate: MyReviewsViewControllerDelegate?
    
    private let viewModel: MyReviewsViewModel
    
    init(_ vm: MyReviewsViewModel) {
        viewModel = vm
        super.init()
        
        title = "나의 여행 후기"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        
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
        
        configureCollectionView()
        updateSections()
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.datum)
        dataSource?.apply(snapshot, animatingDifferences: true)
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
        let vc = ReviewDetailViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyReviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = NSString(string: "jkwbfkewbfoubweofbweo")
            .boundingRect(
                with: CGSize(width:  UIScreen.main.width - 32, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)
                ],
                context: nil)

        return CGSize(width: UIScreen.main.width - 32, height: 380)
    }
}

