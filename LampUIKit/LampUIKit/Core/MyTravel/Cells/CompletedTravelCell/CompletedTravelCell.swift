//
//  CompletedTravelCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//
import CombineCocoa
import Combine
import UIKit

protocol CompletedTravelCellDelegate: AnyObject {
    func completedTravelCellDidTapDelete(at index: Int)
    func completedTravelCellDidTap(_ item: MyCompletedTripLocation)
}

final class CompletedTravelCell: UICollectionViewCell {
    static let identifier = "CompletedTravelCell"
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MyCompletedTripLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyCompletedTripLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    weak var delegate: CompletedTravelCellDelegate?
    
    private let collectionView = BaseCollectionViewWithHeader<CompletedTravelHeaderCell, CompletedTravelCellCollectionViewCell>(.vertical)
    
    private lazy var refreshcontrol = UIRefreshControl()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
    }
    
    private var viewModel: CompletedTravelCellViewModel?
    
    public func configure(_ vm: CompletedTravelCellViewModel) {
        self.viewModel = vm
        
        fetchCompletedTravel()
        updateSections()
        bind()
    }
    
    private func fetchCompletedTravel() {
        viewModel?.fetchCompletedTravel()
    }
    
    private func deleteCompletedTravel(at index: Int) {
        viewModel?.deleteCompletedTravel(at: index)
    }
    
    private func bind() {
        viewModel?
            .notifyPublisher
            .sink(receiveValue: {[weak self] noti in
                guard let self = self else { return }
                switch noti {
                case .endRefreshing:
                    self.refreshcontrol.endRefreshing()
                    
                case .reload:
                    self.updateSections()
                }
            })
            .store(in: &cancellables)
        
        refreshcontrol
            .isRefreshingPublisher
            .sink {[weak self] isRefreshing in
                guard let self = self else {return }
                if isRefreshing {
                    self.viewModel?.setIsRefreshing = true
                    self.fetchCompletedTravel()
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel?.models ?? [])
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {[weak self] in
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
        
        dataSource = DataSource(collectionView: collectionView) {[weak self] collectionView, indexPath, model in
            guard let self = self else {return .init()}
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CompletedTravelCellCollectionViewCell.identifier,
                for: indexPath) as? CompletedTravelCellCollectionViewCell,
                let viewModel = self.viewModel
            else { return .init() }
            cell.tag = indexPath.item
            cell.delegate = self
            cell.configure(viewModel.models[indexPath.item])
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompletedTravelHeaderCell.identifier, for: indexPath) as? CompletedTravelHeaderCell
            return view
        }
    }
    
    private func setupUI() {
        collectionView.refreshControl = refreshcontrol
        showEmptyStateView(with: Message.emptyCompletedTravel)
        
        configureCollectionView()
        
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

//MARK: - CompletedTravelCellCollectionViewCellDelegate
extension CompletedTravelCell: CompletedTravelCellCollectionViewCellDelegate {
    func completedTravelCellCollectionViewCellDidTapDelete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in
            self?.deleteCompletedTravel(at: index)
        }
    }
}

//MARK: - UICollectionViewDelegate
extension CompletedTravelCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.feedBack(with: .heavy)
        guard let viewModel = viewModel else {return }
        delegate?.completedTravelCellDidTap(viewModel.models[indexPath.item])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CompletedTravelCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 170)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
}
