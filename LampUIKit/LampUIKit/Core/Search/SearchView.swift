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
}

class SearchView: BaseView {
    
    private(set) lazy var acationPublisher = actionSubject.eraseToAnyPublisher()
    private let actionSubject = PassthroughSubject<SearchViewAction, Never>()
    
    private(set) lazy var searchBar = UISearchBar(frame: .init(x: 0, y: 0, width: self.frame.width, height: 64))
    
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
    
    override init() {
        super.init()
        bind()
        setupUI()
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    private func bind() {
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
        searchBar.searchTextField.textColor = .midNavy
        searchBar.tintColor = .midNavy
        searchBar.barTintColor = .whiteGrey
        searchBar.searchBarStyle = .prominent
        
        let sv = UIStackView(arrangedSubviews: [searchBar, collectionView])
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
