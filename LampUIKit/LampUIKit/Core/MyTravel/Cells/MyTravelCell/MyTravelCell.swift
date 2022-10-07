//
//  MyTravelCell.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/18.
//

import Combine
import UIKit

protocol MyTravelCellDelegate: AnyObject {
    func myTravelCellDelegateDidTap(_ item: MyTravelLocation)
    func myTravelCellDelegateDidTapDelete(at index: Int)
    func myTravelCellDelegateDidTapComplete(at index: Int)
    func myTravelCellDelegateDidReceiveResponse(_ message: String)
}

final class MyTravelCell: UICollectionViewCell {
    static let identifier = "MyTravelCell"
    
    weak var delegate: MyTravelCellDelegate?
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MyTravelLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyTravelLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private lazy var collectionView = BaseCollectionViewWithHeader<MyTravelCellHeaderCell, MyTravelCellCollectionViewCell>()
    
    private lazy var refreshcontrol = UIRefreshControl()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
    }
    
    private var viewModel: MyTravelCellViewModel?
    
    public func configure(_ vm: MyTravelCellViewModel) {
        self.viewModel = vm
        
        updateSections()
    }
    
    private func bind() {
        viewModel?
            .notifyPublisher
            .sink(receiveValue: {[weak self] notification in
                guard let self = self else {return }
                switch notification {
                case .reload:
                    self.updateSections()
                    
                case .showMessage(let message):
                    self.delegate?.myTravelCellDelegateDidReceiveResponse(message)
                    
                case .endRefreshing:
                    self.refreshcontrol.endRefreshing()
                }
            })
            .store(in: &cancellables)
        
        refreshcontrol
            .isRefreshingPublisher
            .sink {[weak self] isRefreshing in
                guard let self = self else {return }
                if isRefreshing {
                }
            }
            .store(in: &cancellables)
    }
    }
    
    public func deleteMyTravel(at index: Int) {
    }
    
    
    }
}

extension MyTravelCell: MyTravelCellHeaderCellDelegate {
    func myTravelCellHeaderCellDidSelectComplete() {
        viewModel?.toggleShowDeleteButton
        collectionView.reloadData()
    }
    
    func myTravelCellHeaderCellDidSelectEdit() {
        viewModel?.toggleShowDeleteButton
        collectionView.reloadData()
    }
}

extension MyTravelCell: MyTravelCellCollectionViewCellDelegate {
    func myTravelCellCollectionViewCellDidTapComplete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.completeTrip(at: index)
        }
    }
    
    func myTravelCellCollectionViewCellDidTapDelete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.deleteMyTravel(at: index)
        }
    }
}

extension MyTravelCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.feedBack(with: .heavy)
        guard let viewModel = viewModel else {return }
        delegate?.myTravelCellDelegateDidTap(viewModel.models[indexPath.item])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MyTravelCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 254)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
}

//MARK: - set up UI
extension MyTravelCell {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel?.models ?? [])
        dataSource?.apply(snapshot, animatingDifferences: true, completion: { [weak self] in
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
                    withReuseIdentifier: MyTravelCellCollectionViewCell.identifier,
                    for: indexPath) as? MyTravelCellCollectionViewCell,
                let viewModel = self.viewModel
            else { return .init() }
            cell.delegate = self
            cell.tag = indexPath.item
            cell.showDeleButton = self.viewModel?.showDeleteButton
            cell.configure(viewModel.models[indexPath.item])
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyTravelCellHeaderCell.identifier, for: indexPath) as? MyTravelCellHeaderCell
            view?.delegate = self
            return view
        }
    }
    
    private func setupUI() {
        
        showEmptyStateView(with: Message.emptyMyTravel)
        
        configureCollectionView()
        
        [collectionView].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
