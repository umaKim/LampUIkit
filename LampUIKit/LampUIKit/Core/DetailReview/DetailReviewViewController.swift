//
//  DetailReviewViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/24.
//

import UIKit

class DetailReviewViewController: BaseViewContronller {

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ReviewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ReviewModel>
    
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
        
        configureCollectionView()
        updateSections()
    }
    
    private func configureCollectionView() {
        dataSource = DataSource(collectionView: contentView.collectionView) { collectionView, indexPath, model in
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailReviewViewCollectionViewCell.identifier,
                for: indexPath) as? DetailReviewViewCollectionViewCell
            else { return nil }
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailReviewCollectionViewHeader.identifier, for: indexPath) as? DetailReviewCollectionViewHeader
            return view
        }
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.models)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        })
    }
}

extension DetailReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: UIScreen.main.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width / 2, height: 250)
    }
}

struct ReviewModel: Decodable, Hashable {
    let imageUrl: String
    let rating: String
    let comments: String
}
