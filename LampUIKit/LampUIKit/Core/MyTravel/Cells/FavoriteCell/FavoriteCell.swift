//
//  FavoriteCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//

import UIKit

protocol FavoriteCellDelegate: AnyObject {
    func favoriteCellDidTap(_ item: MyBookMarkLocation)
    func favoriteCellDidTapDelete(at index: Int)
}

final class FavoriteCell: UICollectionViewCell {
    static let identifier = "FavoriteCell"
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MyBookMarkLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyBookMarkLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    weak var delegate: FavoriteCellDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(FavoriteCellHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: FavoriteCellHeaderCell.identifier)
        cv.register(FavoriteCellCollectionViewCell.self, forCellWithReuseIdentifier: FavoriteCellCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        fetchSavedTravel()
    }
    
    private var models: [MyBookMarkLocation] = []
    
    public func configure(models: [MyBookMarkLocation]) {
        self.models = models
        self.updateSections()
    }
    
    private func fetchSavedTravel() {
        NetworkService.shared.fetchSavedTravel {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let locations):
                self.models = locations
//                self.notifySubject.send(.reload)
                self.updateSections()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func deleteMySaveLocations(at index: Int) {
        let targetItem = models[index]
        NetworkService.shared.updateBookMark(of: "\(targetItem.contentId)",
                                             "\(targetItem.mapX )",
                                             "\(targetItem.mapY )",
                                             "\(targetItem.contentTypeId)",
                                             placeName: "\(targetItem.placeName )",
                                             placeAddr: "\(targetItem.placeAddr )") { result in
            
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoriteCell: FavoriteCellCollectionViewCellDelegate {
    func favoriteCellCollectionViewCellDidTapDelete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in
            self?.deleteMySaveLocations(at: index)
            self?.models.remove(at: index)
            self?.updateSections()
        }
    }
}

extension FavoriteCell: FavoriteCellHeaderCellDelegate {
    func favoriteCellHeaderCellDidSelectEdit() {
        
    }
    
    func favoriteCellHeaderCellDidSelectComplete() {
        
    }
}

extension FavoriteCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.favoriteCellDidTap(models[indexPath.item])
    }
}

extension FavoriteCell {
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
        
        dataSource = DataSource(collectionView: collectionView) {[weak self] collectionView, indexPath, model in
            guard let self = self else {return nil}
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FavoriteCellCollectionViewCell.identifier,
                for: indexPath) as? FavoriteCellCollectionViewCell
            else { return nil }
            cell.delegate = self
            cell.tag = indexPath.item
            cell.configure(self.models[indexPath.item])
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                kind == UICollectionView.elementKindSectionHeader,
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: FavoriteCellHeaderCell.identifier,
                                                                           for: indexPath) as? FavoriteCellHeaderCell
            else { return nil }
            view.delegate = self
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

extension FavoriteCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
}
