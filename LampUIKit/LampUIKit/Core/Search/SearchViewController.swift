//
//  SearchViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import Combine
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchViewControllerDidTapDismiss()
    func searchViewControllerDidTapMapPin()
}

class SearchViewController: BaseViewContronller {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, RecommendedLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RecommendedLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    weak var delegate: SearchViewControllerDelegate?
    
    private(set) lazy var contentView = SearchView()
    
    private let viewModel: SearchViewModel
    
    init(vm: SearchViewModel) {
        self.viewModel = vm
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.searchBar.placeholder = "검색어 입력"
        navigationItem.titleView = contentView.searchBar
        
        navigationItem.rightBarButtonItems = [contentView.dismissButton]
        contentView.collectionView.delegate = self
        
        bind()
        configureCollectionView()
    }
    
    private func bind() {
        contentView
            .acationPublisher
            .sink {[unowned self] action in
                switch action {
                case .all:
                    //Relod
                    break
                    
                case .recommend:
                    //Relod
                    break
                    
                case .travel:
                    //Relod
                    break
                    
                case .notVisit:
                    //Reload
                    break
                    
                case .dismiss:
                    self.delegate?.searchViewControllerDidTapDismiss()
                    
                case .searchTextDidChange(let text):
                    self.viewModel.search(text)
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[unowned self] notify in
                switch notify {
                case .reload:
                    self.updateSections()
                    
                case .startLoading:
                    self.showLoadingView()
                    
                case .endLoading:
                    self.dismissLoadingView()
                }
            }
            .store(in: &cancellables)
    }
}

extension SearchViewController: SearchRecommendationCollectionViewCellDelegate {
    func didTapFavoriteButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.save(index)
    }
    
    func didTapSetThisLocationButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.postAddToMyTrip(at: index, location)
    }
    
    func didTapMapPin() {
        contentView.searchBar.endEditing(true)
        delegate?.searchViewControllerDidTapMapPin()
    }
    
    func didTapCancelThisLocationButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.deleteFromMyTrip(at: index, location)
    }
}

extension SearchViewController {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.locations)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCollectionView() {
        contentView.collectionView.delegate = self
        
        dataSource = DataSource(collectionView: contentView.collectionView,
                                cellProvider: {[unowned self] collectionView, indexPath, itemIdentifier in
            guard
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecommendationCollectionViewCell.identifier, for: indexPath) as? SearchRecommendationCollectionViewCell
            else { return UICollectionViewCell() }
            cell.tag = indexPath.item
            cell.configure(with: self.viewModel.locations[indexPath.item])
            cell.delegate = self
            return cell
        })
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vm = LocationDetailViewModel(viewModel.locations[indexPath.item])
        let vc = LocationDetailViewController(vm: vm)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 32, height: 175)
    }
}
