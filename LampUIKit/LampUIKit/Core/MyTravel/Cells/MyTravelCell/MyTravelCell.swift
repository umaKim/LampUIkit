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
}

final class MyTravelCell: UICollectionViewCell {
    static let identifier = "MyTravelCell"
    
    weak var delegate: MyTravelCellDelegate?
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, MyTravelLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyTravelLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    private lazy var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(MyTravelCellHeaderCell.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: MyTravelCellHeaderCell.identifier)
        cv.register(MyTravelCellCollectionViewCell.self, forCellWithReuseIdentifier: MyTravelCellCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.delegate = self
        cv.refreshControl = refreshcontrol
        return cv
    }()
    
    private lazy var refreshcontrol = UIRefreshControl()
    
    private var cancellables: Set<AnyCancellable>
    
    override init(frame: CGRect) {
        self.cancellables = .init()
        super.init(frame: frame)
        setupUI()
        fetchMyTravel(completion: {})
        refreshcontrol
            .isRefreshingPublisher
            .sink {[weak self] isRefreshing in
                guard let self = self else {return }
                if isRefreshing {
                    self.fetchMyTravel {
                        self.refreshcontrol.endRefreshing()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private var models: [MyTravelLocation] = []
    private var showDeleteButton: Bool = false
    
    public func configure() {
        updateSections()
    }
    
    private func fetchMyTravel(completion: @escaping () -> Void) {
        NetworkService.shared.fetchMyTravel {[weak self] result in
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
    
    public func deleteMyTravel(at index: Int) {
        let targetItem = models[index]
        models.remove(at: index)
        NetworkService.shared.removeMyTravel(targetItem)
    }
    
    
    public func completeTrip(at index: Int) {
        let myTravel = models[index]
        NetworkService.shared.postCompleteTrip(.init(token: "",
                                                     planIdx: myTravel.planIdx,
                                                     mapX: myTravel.mapX ?? "",
                                                     mapY: myTravel.mapY ?? "")) {[weak self] result in
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyTravelCell: MyTravelCellHeaderCellDelegate {
    func myTravelCellHeaderCellDidSelectComplete() {
        showDeleteButton.toggle()
        collectionView.reloadData()
    }
    
    func myTravelCellHeaderCellDidSelectEdit() {
        showDeleteButton.toggle()
        collectionView.reloadData()
    }
}

extension MyTravelCell: MyTravelCellCollectionViewCellDelegate {
    func myTravelCellCollectionViewCellDidTapComplete(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.completeTrip(at: index, completion: {
                self?.models.remove(at: index)
                self?.updateSections()
            })
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
        delegate?.myTravelCellDelegateDidTap(models[indexPath.item])
    }
}

extension MyTravelCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.width - 32, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: UIScreen.main.width, height: 60)
    }
}

//MARK: - set up UI
extension MyTravelCell {
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
                    withReuseIdentifier: MyTravelCellCollectionViewCell.identifier,
                    for: indexPath) as? MyTravelCellCollectionViewCell
            else { return nil }
            cell.delegate = self
            cell.tag = indexPath.item
            cell.showDeleButton = self.showDeleteButton
            cell.configure(self.models[indexPath.item])
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
