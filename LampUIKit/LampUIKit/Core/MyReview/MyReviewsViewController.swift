//
//  ReviewViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/21.
//

import UIKit

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
//            cell.configure(with: self.viewModel.datum[indexPath.item])
//            cell.delegate = self
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyReviewHeaderCell.identifier, for: indexPath) as? MyReviewHeaderCell
//            view?.delegate = self
            view?.configure()
            return view
        }
    }
}

extension MyReviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 100)
    }
}
