//
//  DetailReviewViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//

import UIKit

class DetailReviewViewController: BaseViewContronller {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ReviewData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ReviewData>
    
    enum Section { case main }
    
    private let contentView = DetailReviewView()

    private var dataSource: DataSource?

    init(vm: DetailReviewViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: DetailReviewViewModel
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.collectionView.delegate = self
        
        navigationItem.leftBarButtonItems = [contentView.backButton]
        navigationItem.rightBarButtonItems = [contentView.reportButton]
        
        configureCollectionView()
        updateSections()
        bind()
    }
    
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .back:
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] noti in
                guard let self = self else {return}
                switch noti {
                case .reload:
                    self.updateSections()
                    
                case .message(let text):
                    self.presentUmaDefaultAlert(title: text)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureCollectionView() {
        dataSource = DataSource(collectionView: contentView.collectionView) {[weak self] collectionView, indexPath, model in
            guard let self = self else { return nil}
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailReviewViewCollectionViewCell.identifier,
                for: indexPath) as? DetailReviewViewCollectionViewCell
            else { return nil }
            cell.tag = indexPath.row
            cell.delegate = self
            cell.configure(self.viewModel.reviews[indexPath.item])
            return cell
        }
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self else {return nil}
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DetailReviewCollectionViewHeader.identifier,
                for: indexPath) as? DetailReviewCollectionViewHeader
            view?.configure(self.viewModel.location, self.viewModel.locationDetail)
            return view
        }
    }

    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.reviews)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: { [weak self] in
            guard let self = self else {return}
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        })
    }
}

extension DetailReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailReviewCollectionViewHeader.identifier,
            for: indexPath)
        let size = headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width / 2 - 24, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

extension DetailReviewViewController: DetailReviewViewCollectionViewCellDelegate {
    func detailReviewViewCollectionViewCellDidTapUnlikeButton(_ index: Int) {
        
    }
    
    func detailReviewViewCollectionViewCellDidTapLikeButton(_ index: Int) {
        viewModel.didTapLike(at: index)
    }
    
    func detailReviewViewCollectionViewCellDidTapReportButton(_ index: Int) {
        viewModel.didTapReport(at: index)
    }
}
