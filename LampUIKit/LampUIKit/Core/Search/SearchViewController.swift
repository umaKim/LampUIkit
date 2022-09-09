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
    func searchViewControllerDidTapMapPin(at location: RecommendedLocation)
    func searchViewControllerDidTapNavigation(at location: RecommendedLocation)
    func searchBarDidTap()
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
        
        navigationItem.searchController = contentView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        contentView.searchController.searchBar.placeholder = "검색어 입력".localized
        
        navigationItem.leftBarButtonItems = [contentView.dismissButton]
        contentView.collectionView.delegate = self
        
        bind()
        configureCollectionView()   
    }
    
    private func bind() {
        contentView
            .acationPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
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
                    self.viewModel.setKeyword(text)
                    
                case .searchDidBeginEditing:
                    self.delegate?.searchBarDidTap()
                    
                case .didTapSearchButton:
                    self.viewModel.searchButtonDidTap()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .notifyPublisher
            .sink {[weak self] notify in
                guard let self = self else {return}
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (contentView.collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            self.viewModel.fetchSearchKeywordData()
        }
    }
}

extension SearchViewController: SearchRecommendationCollectionViewCellDelegate {
    func didTapFavoriteButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.save(index)
    }
    
    func didTapSetThisLocationButton(at index: Int, _ location: RecommendedLocation) {
        viewModel.postAddToMyTrip(at: index, location)
    }
    
    func didTapMapPin(location: RecommendedLocation) {
        contentView.searchController.searchBar.endEditing(true)
        delegate?.searchViewControllerDidTapMapPin(at: location)
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
                                cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {return nil}
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

extension SearchViewController: LocationDetailViewControllerDelegate {
    func locationDetailViewControllerDidTapNavigate(_ location: RecommendedLocation) {
        self.delegate?.searchViewControllerDidTapNavigation(at: location)
    }
    
    func locationDetailViewControllerDidTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func locationDetailViewControllerDidTapDismissButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func locationDetailViewControllerDidTapMapButton(_ location: RecommendedLocation) {
        self.didTapMapPin(location: location)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = LocationDetailViewModel(viewModel.locations[indexPath.item])
        let vc = LocationDetailViewController(vm: vm)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 32, height: 175)
    }
}
