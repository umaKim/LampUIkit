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

class SearchViewController: BaseViewController<SearchView, SearchViewModel> {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, RecommendedLocation>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RecommendedLocation>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    weak var delegate: SearchViewControllerDelegate?
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(contentView.collectionView.contentOffset.y >= (contentView.collectionView.contentSize.height - contentView.collectionView.bounds.size.height)) {
            viewModel.isPaginating = true
            viewModel.fetchSearchKeywordData()
        }
    }
    
    deinit {
        view.restoreViews()
    }
}

//MARK: - Bind
extension SearchViewController {
    private func bind() {
        contentView
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .dismiss:
                    HapticManager.shared.feedBack(with: .heavy)
                    self.delegate?.searchViewControllerDidTapDismiss()
                    
                case .searchTextDidChange(let text):
                    HapticManager.shared.feedBack(with: .soft)
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
                    
                case .showMessage(let text):
                    self.presentUmaBottomAlert(message: text)
                }
            }
            .store(in: &cancellables)
    }
}

//MARK: - CollectionView
extension SearchViewController {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.locations)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: {[weak self] in
            guard let self = self else {return }
            self.view.showEmptyStateView(on: self.contentView.collectionView,
                                         when: self.viewModel.locations.isEmpty,
                                         with: Message.emptySearch)
        })
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


//MARK: - SearchRecommendationCollectionViewCellDelegate
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
        viewModel.postAddToMyTrip(at: index, location)
    }
}

//MARK: - LocationDetailViewControllerDelegate
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

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.feedBack(with: .heavy)
        let vm = LocationDetailViewModel(viewModel.locations[indexPath.item])
        let vc = LocationDetailViewController(LocationDetailView(), vm)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 32, height: 145)
    }
}
