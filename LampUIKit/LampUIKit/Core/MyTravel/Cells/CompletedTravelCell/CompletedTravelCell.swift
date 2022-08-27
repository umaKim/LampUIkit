//
//  CompletedTravelCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//

import UIKit

final class CompletedTravelCell: UICollectionViewCell {
    static let identifier = "CompletedTravelCell"
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MyTravelLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyTravelLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(CompletedTravelHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: CompletedTravelHeaderCell.identifier)
        cv.register(CompletedTravelCellCollectionViewCell.self, forCellWithReuseIdentifier: CompletedTravelCellCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            self.dataSource?.applySnapshotUsingReloadData(snapshot)
        })
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        
        dataSource = DataSource(collectionView: collectionView) {[unowned self] collectionView, indexPath, model in
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CompletedTravelCellCollectionViewCell.identifier,
                for: indexPath) as? CompletedTravelCellCollectionViewCell
            else { return nil }
//            cell.delegate = self
            cell.tag = indexPath.item
//            cell.configure(self.models[indexPath.item])
//            cell.showDeleButton = self.showDeleteButton
            cell.configure(self.models[indexPath.item])
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompletedTravelHeaderCell.identifier, for: indexPath) as? CompletedTravelHeaderCell
//            view?.delegate = self
            return view
        }
    }
    
    private func setupUI() {
        configureCollectionView()
        
        backgroundColor = .systemCyan
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension CompletedTravelCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompletedTravelHeaderCell.identifier, for: indexPath) as? CompletedTravelHeaderCell
        else {return .init()}
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedTravelCellCollectionViewCell.identifier, for: indexPath) as? CompletedTravelCellCollectionViewCell
        else {return UICollectionViewCell()}
        return cell
    }
}

