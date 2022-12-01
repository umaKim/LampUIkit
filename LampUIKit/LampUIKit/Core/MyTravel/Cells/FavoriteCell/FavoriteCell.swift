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
    private let collectionView = BaseCollectionViewWithHeader<
        FavoriteCellHeaderCell,
        FavoriteCellCollectionViewCell
    >(.vertical)
    private lazy var refreshcontrol = UIRefreshControl()
    private var cancellables: Set<AnyCancellable>
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
    }
    private func bind() {
        viewModel?
            .notifyPublisher
            .sink(receiveValue: { noti in
                switch noti {
                case .reload:
                    self.updateSections()
                case .endRefreshing:
                    self.refreshcontrol.endRefreshing()
                case .showMessage:
                    break
                }
            })
            .store(in: &cancellables)
        refreshcontrol
            .isRefreshingPublisher
            .sink {[weak self] isRefreshing in
                guard let self = self else {return }
                if isRefreshing {
                    self.viewModel?.setIsRefreshing = true
                    self.fetchSavedTravel()
                }
            }
            .store(in: &cancellables)
    }
    private var viewModel: FavoriteCellViewModel?
    public func configure(_ viewModel: FavoriteCellViewModel) {
        self.viewModel = viewModel
        fetchSavedTravel()
        updateSections()
        bind()
    }
    private func fetchSavedTravel() {
        viewModel?.fetchSavedTravel()
    }
    public func deleteMySaveLocations(at index: Int) {
        viewModel?.deleteMySaveLocations(at: index)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FavoriteCellCollectionViewCellDelegate
extension FavoriteCell: FavoriteCellCollectionViewCellDelegate {
    func favoriteCellCollectionViewCellDidTapDelete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in
            self?.deleteMySaveLocations(at: index)
        }
    }
}

// MARK: - FavoriteCellHeaderCellDelegate
extension FavoriteCell: FavoriteCellHeaderCellDelegate {
    func favoriteCellHeaderCellDidSelectEdit() { }
    func favoriteCellHeaderCellDidSelectComplete() { }
}

// MARK: - UICollectionViewDelegate
extension FavoriteCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.feedBack(with: .heavy)
        guard let viewModel = viewModel else {return }
        delegate?.favoriteCellDidTap(viewModel.models[indexPath.item])
    }
}

// MARK: - Set up UI
extension FavoriteCell {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel?.models ?? [])
        dataSource?.apply(
            snapshot,
            animatingDifferences: true,
            completion: {[weak self] in
                guard
                    let self = self,
                    let viewModel = self.viewModel
                else {return }
                self.collectionView.backgroundColor = viewModel.models.isEmpty ? .clear : .greyshWhite
                self.collectionView.reloadData()
            })
    }
    private func configureCollectionView() {
        collectionView.delegate = self
        dataSource = DataSource(
            collectionView: collectionView
        ) {[weak self] collectionView, indexPath, _ in
            guard let self = self else {return nil}
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FavoriteCellCollectionViewCell.identifier,
                    for: indexPath
                ) as? FavoriteCellCollectionViewCell,
                let viewModel = self.viewModel
            else { return nil }
            cell.delegate = self
            cell.tag = indexPath.item
            cell.configure(viewModel.models[indexPath.item])
            return cell
        }
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                kind == UICollectionView.elementKindSectionHeader,
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FavoriteCellHeaderCell.identifier,
                    for: indexPath
                ) as? FavoriteCellHeaderCell
            else { return nil }
            view.delegate = self
            return view
        }
    }
    private func setupUI() {
        collectionView.refreshControl = refreshcontrol
        showEmptyStateView(with: Message.emptyFavorite)
        configureCollectionView()
        [collectionView].forEach { uiView in
            uiView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uiView)
        }
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 120)
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
}
