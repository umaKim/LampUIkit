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
    
    private lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(CompletedTravelHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: CompletedTravelHeaderCell.identifier)
        cv.register(CompletedTravelCellCollectionViewCell.self,
                    forCellWithReuseIdentifier: CompletedTravelCellCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.refreshControl = refreshcontrol
        return cv
    }()
    
    private lazy var refreshcontrol = UIRefreshControl()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        bind()
        setupUI()
        fetchCompletedTravel(completion: { })
    }
    
    private var models: [MyCompletedTripLocation] = []
    
    public func configure() {
        updateSections()
    }
    
    private func bind() {
        refreshcontrol
            .isRefreshingPublisher
            .sink {[weak self] isRefreshing in
                guard let self = self else {return }
                if isRefreshing {
                    self.fetchCompletedTravel {
                        self.refreshcontrol.endRefreshing()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchCompletedTravel(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchCompletedTravel {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let locations):
                self.models = locations.map { location -> MyCompletedTripLocation in
                        .init(planIdx: location.planIdx ?? "",
                              image: location.image ?? "",
                              travelCompletedDate: location.travelCompletedDate ?? "",
                              contentId: location.contentId,
                              contentTypeId: location.contentTypeId,
                              placeInfo: "",
                              placeAddress: location.addr,
                              userMemo: "",
                              mapX: location.mapX,
                              mapY: location.mapY,
                              placeName: location.title,
                              isBookMarked: location.isBookMarked)
                }
                self.updateSections()
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func deleteCompletedTravel(at index: Int) {
        let targetItem = models[index]
        NetworkManager.shared.deleteFromMyTravel(targetItem.planIdx) {[weak self] result in
            switch result {
            case .success(let response):
                self?.models.remove(at: index)
                self?.updateSections()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {[weak self] in
            guard let self = self else {return }
            self.collectionView.backgroundColor = self.models.isEmpty ? .clear : .greyshWhite
            self.collectionView.reloadData()
        })
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        
        dataSource = DataSource(collectionView: collectionView) {[weak self] collectionView, indexPath, model in
            guard let self = self else {return nil}
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CompletedTravelCellCollectionViewCell.identifier,
                for: indexPath) as? CompletedTravelCellCollectionViewCell
            else { return nil }
            cell.tag = indexPath.item
            cell.delegate = self
            cell.configure(self.models[indexPath.item])
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CompletedTravelHeaderCell.identifier, for: indexPath) as? CompletedTravelHeaderCell
            return view
        }
    }
    
    private func setupUI() {
        showEmptyStateView(with: Message.emptyCompletedTravel)
        
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
        delegate?.completedTravelCellDidTap(models[indexPath.item])
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
