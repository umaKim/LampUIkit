//
//  SearchViewController.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//

import Combine
import UIKit

class SearchViewController: BaseViewContronller {

    private let contentView = SearchView()
    
    private let viewModel: SearchViewModel
    
    init(vm: SearchViewModel) {
        self.viewModel = vm
        self.cancellables = .init()
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
        
        contentView.searchBar.placeholder = "Search User"
        navigationItem.titleView = contentView.searchBar

        navigationItem.rightBarButtonItems = [contentView.arButton]
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
        
        bind()
    }
    
    private var cancellables: Set<AnyCancellable>
    
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
                    
                case .ar:
                    //Present AR
                    break
                    
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
                    self.contentView.reload()
                }
            }
            .store(in: &cancellables)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchRecommendationCollectionViewCell.identifier, for: indexPath) as? SearchRecommendationCollectionViewCell
        else {return UICollectionViewCell()}
        cell.configure(with: viewModel.items[indexPath.item])
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: UIScreen.main.bounds.width - 32, height: 175)
    }
}
