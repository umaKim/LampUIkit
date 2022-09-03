//
//  SearchView.swift
//  LampUIKit
//
//  Created by 김윤석 on 2022/07/14.
//
import Combine
import CombineCocoa
import UIKit

enum SearchViewAction {
    case all
    case recommend
    case travel
    case notVisit
    
    case dismiss
    
    case searchTextDidChange(String)
    case searchDidBeginEditing
    case didTapSearchButton
}

class SearchView: BaseView {
    
    private(set) lazy var acationPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchViewAction, Never>()
    
    private(set) var dismissButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .back, style: .done, target: nil, action: nil)
        return bt
    }()
    
    private let categoryButtons = CategoryButtonView()
    
    private(set) var collectionView: UICollectionView = {
        let cl = UICollectionViewFlowLayout()
        cl.scrollDirection = .vertical
        cl.minimumLineSpacing = 18
        let cv = UICollectionView(frame: .zero, collectionViewLayout: cl)
        cv.register(SearchRecommendationCollectionViewCell.self, forCellWithReuseIdentifier: SearchRecommendationCollectionViewCell.identifier)
        cv.backgroundColor = .greyshWhite
        cv.keyboardDismissMode = .onDrag
        return cv
    }()
    
    private(set) lazy var searchController = UISearchController(searchResultsController: nil)
    
    func setupSearchController() {
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    override init() {
        super.init()
        bind()
        setupUI()
        
        setupSearchController()
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    private func bind() {
        let searchBar = searchController.searchBar
        
        searchBar
            .textDidChangePublisher
            .sink {[weak self] text in
                guard let self = self else {return}
                self.actionSubject.send(.searchTextDidChange(text))
            }
            .store(in: &cancellables)
        
        searchBar
            .searchTextField
            .didBeginEditingPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.searchDidBeginEditing)
            }
            .store(in: &cancellables)
        
        searchBar
            .searchButtonClickedPublisher
            .sink { [weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.didTapSearchButton)
            }
            .store(in: &cancellables)
        
        dismissButton
            .tapPublisher
            .sink {[weak self] _ in
                guard let self = self else {return}
                self.actionSubject.send(.dismiss)
            }
            .store(in: &cancellables)
        
        categoryButtons
            .actionPublisher
            .sink {[weak self] action in
                guard let self = self else {return}
                switch action {
                case .all:
                    self.actionSubject.send(.all)
                case .recommend:
                    self.actionSubject.send(.recommend)
                case .travel:
                    self.actionSubject.send(.travel)
                case .notVisit:
                    self.actionSubject.send(.notVisit)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
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
