//
//  SearchView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//
import Combine
import CombineCocoa
import UIKit

enum SearchViewAction: Actionable {
    case dismiss
    case searchTextDidChange(String)
    case searchDidBeginEditing
    case didTapSearchButton
}

class SearchView: BaseView<SearchViewAction> {
    
    private(set) var dismissButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private(set) lazy var searchController = UISearchController(searchResultsController: nil)
    
    private(set) var collectionView = BaseCollectionView<SearchRecommendationCollectionViewCell>(.vertical, 18)
    
    override init() {
        super.init()
        
        setupSearchController()
        bind()
        setupUI()
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func bind() {
        let searchBar = searchController.searchBar
        searchBar.showsCancelButton = false
        
        searchBar
            .textDidChangePublisher
            .sink {[weak self] text in
                guard let self = self else {return}
                self.sendAction(.searchTextDidChange(text))
            }
            .store(in: &cancellables)
        
        searchBar
            .searchTextField
            .didBeginEditingPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.searchDidBeginEditing)
            }
            .store(in: &cancellables)
        
        searchBar
            .searchButtonClickedPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.sendAction(.didTapSearchButton)
            }
            .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.sendAction(.dismiss)
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        collectionView.keyboardDismissMode = .onDrag
        
        let sv = UIStackView(arrangedSubviews: [collectionView])
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 16
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = .greyshWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
