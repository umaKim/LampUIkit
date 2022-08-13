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
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, LocationItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, LocationItem>
    
    enum Section { case main }
    
    private var dataSource: DataSource?
    
    weak var delegate: SearchViewControllerDelegate?
    
    private let contentView = SearchView()
    
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
//        contentView.collectionView.dataSource = self
        
        bind()
        configureCollectionView()
    }
    
    private func bind() {
        contentView
            .acationPublisher
            .sink { action in
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
            .sink { notify in
                switch notify {
                case .reload:
                    //                    self.contentView.reload()
                    self.updateSections()
                }
            }
            .store(in: &cancellables)
    }
}

extension SearchViewController: SearchRecommendationCollectionViewCellDelegate {
    func didTapSetThisLocationButton() {
        
    }
    
    func didTapMapPin() {
        contentView.searchBar.endEditing(true)
        delegate?.searchViewControllerDidTapMapPin()
    }
    
    func didTapFavoriteButton(at index: Int, _ isFavorite: Bool) {
        print(index)
        print(isFavorite)
    }
}

extension SearchViewController {
    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureCollectionView() {
        contentView.collectionView.delegate = self
        
        dataSource = DataSource(collectionView: contentView.collectionView,
                                cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecommendationCollectionViewCell.identifier, for: indexPath) as? SearchRecommendationCollectionViewCell else { return UICollectionViewCell() }
            cell.tag = indexPath.item
            cell.configure(with: self.viewModel.items[indexPath.item])
            cell.delegate = self
            return cell
        })
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = LocationDetailViewModel()
        let vc = LocationDetailViewController(vm: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 32, height: 175)
    }
}
