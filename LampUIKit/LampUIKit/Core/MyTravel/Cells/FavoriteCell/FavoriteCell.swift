//
//  FavoriteCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//
import Combine
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
        cv.refreshControl = refreshcontrol
        return cv
    }()
    
    private lazy var refreshcontrol = UIRefreshControl()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
        fetchSavedTravel(completion: {})
        
        refreshcontrol
            .isRefreshingPublisher
            .sink {[weak self] isRefreshing in
                guard let self = self else {return }
                if isRefreshing {
                    self.fetchSavedTravel {
                        self.refreshcontrol.endRefreshing()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private var models: [MyBookMarkLocation] = []
    
    public func configure() {
        self.updateSections()
    }
    
    private func fetchSavedTravel(completion: @escaping () -> Void) {
        NetworkService.shared.fetchSavedTravel {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let locations):
                self.models = locations
                self.updateSections()
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func deleteMySaveLocations(at index: Int) {
        let targetItem = models[index]
        NetworkService.shared.updateBookMark(of: "\(targetItem.contentId)",
                                             contentTypeId: "\(targetItem.contentTypeId)",
                                             mapx: "\(targetItem.mapX)",
                                             mapY: "\(targetItem.mapY)",
                                             placeName: "\(targetItem.placeName )",
                                             placeAddr: "\(targetItem.placeAddr )") {[weak self] result in
            
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
        HapticManager.shared.feedBack(with: .heavy)
        delegate?.favoriteCellDidTap(models[indexPath.item])
    }
}

extension FavoriteCell {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {
            self.collectionView.reloadData()
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
