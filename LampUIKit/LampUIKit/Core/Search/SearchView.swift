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
}

class SearchView: UIView {
    
    private(set) lazy var acationPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchViewAction, Never>()
    
    private(set) var searchBar = UISearchBar()
    
    private(set) var arButton: UIBarButtonItem = {
    private(set) var dismissButton: UIBarButtonItem = {
        let bt = UIBarButtonItem(image: .xmark, style: .done, target: nil, action: nil)
        bt.tintColor = .black
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
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(frame: .zero)
        
        bind()
        setupUI()
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    private func bind() {
        searchBar.textDidChangePublisher
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink { text in
            self.actionSubject.send(.searchTextDidChange(text))
        }
        .store(in: &cancellables)
        
        dismissButton.tapPublisher.sink { _ in
            self.actionSubject.send(.dismiss)
        }
        .store(in: &cancellables)
        
        categoryButtons.actionPublisher.sink { action in
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
        searchBar.searchTextField.textColor = .midNavy
        searchBar.tintColor = .midNavy
        
        let sv = UIStackView(arrangedSubviews: [categoryButtons, collectionView])
        sv.alignment = .fill
        sv.distribution = .fill
        sv.axis = .vertical
        sv.spacing = 16
        
        [sv].forEach { uv in
            uv.translatesAutoresizingMaskIntoConstraints = false
            addSubview(uv)
        }
        
        NSLayoutConstraint.activate([
            categoryButtons.heightAnchor.constraint(equalToConstant: 30),
            
            sv.topAnchor.constraint(equalTo: topAnchor),
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
